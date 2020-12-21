classdef Region < handle
    
    properties (Access = ?Region)
        Name char
        Cases % Cumulative
        Deaths % Cumulative
        Daily_Cases
        Daily_Deaths
        Subregions cell
    end
    
    methods
        function obj = Region(name, days)
            obj.Name = name;
            obj.Cases = zeros(1, days);
            obj.Deaths = zeros(1, days);
            obj.Daily_Cases = zeros(1, days);
            obj.Daily_Deaths = zeros(1, days);
            obj.Subregions = {};
        end
        
        function setStats(obj, index, numCases, numDeaths)
            if index == 1
                prev_cases = 0;
                prev_deaths = 0;
            else
                prev_cases = obj.Cases(1, index - 1);
                prev_deaths = obj.Deaths(1, index - 1);
            end
            
            obj.Daily_Cases(1, index) = numCases - prev_cases;
            obj.Daily_Deaths(1, index) = numDeaths - prev_deaths;
            obj.Cases(1, index) = numCases;
            obj.Deaths(1, index) = numDeaths;
        end
        
        function calcStats(obj)
            for k = 1:length(obj.Subregions)
                subregion = obj.Subregions{1, k};
                obj.Cases = obj.Cases + subregion.Cases;
                obj.Deaths = obj.Deaths + subregion.Deaths;
                obj.Daily_Cases = obj.Daily_Cases + subregion.Daily_Cases;
                obj.Daily_Deaths = obj.Daily_Deaths + subregion.Daily_Deaths;
            end
        end
        
        function addRegion(obj, newRegion)
           obj.Subregions{end + 1} = newRegion;
        end
        
        function country = getSubregion(obj, index)
           country = obj.Subregions{1, index};
        end
        
        function name = getName(obj)
           name = obj.Name;
        end
        
        function names = getSubregionNames(obj)
            names = cell(1, length(obj.Subregions));
            
            for k = 1:length(obj.Subregions)
                names{1, k} = obj.Subregions{k}.Name;
            end
        end
        
        function [cases, deaths] = getData(obj, is_cumulative)
            if is_cumulative
                cases = obj.Cases;
                deaths = obj.Deaths;
            else
                cases = obj.Daily_Cases;
                deaths = obj.Daily_Deaths;
            end
        end
    end
end

