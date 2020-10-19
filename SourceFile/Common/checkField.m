function opt = checkField(S,field,classes,attributes,default)
    if ~isfield(S,field) ||...
        isempty(getfield(S,field)) 
        opt = setfield(S,field,default);
    else
        validateattributes(getfield(S,field),classes,attributes);
        opt = S;
    end
end