module HasFinder
  class FinderProxy
    attr_reader :proxy_finder, :proxy_scope
    [].methods.each { |m| delegate m, :to => :proxy_found unless m =~ /(^__|^nil\?|^send|class|extend|find|count|sum|average|maximum|minimum|paginate)/ }
    delegate :finders, :with_scope, :to => :proxy_finder
    
    def initialize(proxy_finder, options, &block)
      extend options.delete(:extend) if options[:extend]
      extend Module.new(&block) if block_given?
      @proxy_finder, @proxy_scope = proxy_finder, options
    end
    
    def reload
      load_found; self
    end
    
    def to_filtered
      HasFinderHelper.filter_for(proxy_finder).wrap(proxy_found.to_a)
    end
    
    protected
    def proxy_found
      @found ||= load_found
    end
    
    private
    def method_missing(method, *args, &block)      
      scope = proxy_scope.delete(:scope)
      if finders.include?(method)
        if scope
          with_scope :find => proxy_scope do
            self.send(scope).send(method, *args, &block)
          end
        else
          finders[method].call(self, *args)
        end
      else
        if scope
          with_scope :find => proxy_scope do
            self.send(scope)
          end
        else
          with_scope :find => proxy_scope do
            proxy_finder.send(method, *args, &block)
          end
        end
      end
    end
    
    def load_found
      find(:all)
    end
  end

  module ActiveRecord
    def self.included(ar)
      ar.extend ClassMethods
      class << ar; self; end.send(:alias_method_chain, :find, :to_filtered)
    end

    module ClassMethods
      def finders
        write_inheritable_attribute(:finders, {}) if read_inheritable_attribute(:finders).nil?
        read_inheritable_attribute(:finders)
      end
      
      def has_finder(name, options = {}, &block)
        finders[name] = lambda do |parent_finder, *args|
          FinderProxy.new(parent_finder, case options
            when Hash
              options
            when Proc
              options.call(*args)
          end, &block)
        end
        meta_def(name) do |*args|
          finders[name].call(self, *args)
        end
      end
    
      def find_with_to_filtered(*args)
        result = find_without_to_filtered(*args)
        result.extend(ToFilteredForFind)
      end
    end
  end
  
  module ToFilteredForFind
    def to_filtered(clazz = nil)
      return self if self.empty? && !clazz
      HasFinderHelper.filter_for(clazz || first.class).wrap(self)
    end
  end

  module HasManyAssociation
    def self.included(ap)
      ap.class_eval do
        alias_method_chain :method_missing, :has_finder
      end
    end

    def to_filtered
      HasFinderHelper.filter_for(@reflection.klass).wrap(self.to_a)
    end

    def method_missing_with_has_finder(method, *args, &block)
      if @reflection.klass.finders.include?(method)
        @reflection.klass.finders[method].call(self, *args)
      else
        method_missing_without_has_finder(method, *args, &block)
      end
    end
  end
  
  module HasAndBelongsToManyAssociation
    def to_filtered
      HasFinderHelper.filter_for(@reflection.klass).wrap(self.to_a)
    end
  end

  class HasFinderHelper
    def self.filter_for(klass)
      unless klass.superclass == ::ActiveRecord::Base
        klass = klass.ancestors.detect { |c| c.superclass == ::ActiveRecord::Base } 
      end
      
      "Filters::#{klass.name}".constantize
    end
  end
end

ActiveRecord::Base.send(:include, HasFinder::ActiveRecord)
[ActiveRecord::Associations::HasManyAssociation, 
  ActiveRecord::Associations::HasManyThroughAssociation].each do |c|
  c.send(:include, HasFinder::HasManyAssociation)

ActiveRecord::Associations::HasAndBelongsToManyAssociation.send(:include, 
      HasFinder::HasAndBelongsToManyAssociation)
end
