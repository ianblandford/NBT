classdef config < meegpipe.node.abstract_config
    % CONFIG - Configuration bss node
    
   
    properties
        
        PCA             = spt.pca('Criterion', 'aic', 'RetainedVar', 99.99, 'MaxCard', 50);
        BSS             = spt.bss.multicombi;
        RegrFilter      = [];
        Criterion       = spt.criterion.dummy;
        Reject          = true;
        Filter          = [];
        
    end
    
    % Consistency checks
    methods
        
        function obj = set.RegrFilter(obj, value)
            
            import exceptions.*;
            
            if isempty(value) || ...
                    (isnumeric(value) && numel(value) == 1 && isnan(value)),
                obj.RegrFilter = [];
                return;
            end
            
            if ~isa(value, 'filter.rfilt'),
                throw(InvalidPropValue('Filter', ...
                    'Must be a filter.rfilt objects'));
            end
            
            obj.RegrFilter = value;
            
        end
        
        function obj = set.Criterion(obj, value)
            
            import exceptions.*;
            
            if isempty(value),
                value = [];
            end
            
            if ~isa(value, 'spt.criterion.criterion'),
                throw(InvalidPropValue('Criterion', ...
                    'Must be a spt.criterion.criterion object'));
            end
            
            obj.Criterion = value;
            
        end
        
        function obj = set.PCA(obj, value)
            
            import exceptions.*;
            
            if isempty(value),
                obj.PCA = [];
                return;
            end
            
            if ~isa(value, 'spt.pca'),
                throw(InvalidPropValue('PCA', ...
                    'Must be a spt.pca object'));
            end
            
            obj.PCA = value;
            
        end
        
        function obj = set.BSS(obj, value)
            
            import exceptions.*;
            
            if isempty(value),
                obj.BSS = spt.bss.multicombi;
                return;
            end
            
            if ~isa(value, 'spt.spt'),
                throw(InvalidPropValue('BSS', ...
                    'Must be a spt.spt object'));
            end
            
            obj.BSS = value;
            
        end
        
    end
    
    
    % Constructor
    methods
        
        function obj = config(varargin)
            
            obj = obj@meegpipe.node.abstract_config(varargin{:});
            
        end
        
    end
    
    
    
end