function structC = uq_copy_fields(structA, structB, fields_to_copy, ...
    fields_to_copy_opt)
% structC = uq_copy_fields(...
%         structA, structB, fields_to_copy, fields_to_copy_opt)
%     Creates a structure structC which extends structure B with mandatory 
%     and optional fields to be copied from structure A. Raises an error
%     if A lacks one of the mandatory fields (but not if it is missing an  
%     optional field), or if B has any field already, and it is not empty.
%
% INPUT:
% structA : struct
%     structure whose fields must be copied from
% structB : struct
%     structure whose fields must be copied into (non-hard copy)
% fields_to_copy : cell array, optional
%     which fields of structA to copy. If not specified, all fields are
%     copied
% fields_to_copy_opt : cell array, optional
%     which fields of structA to copy, when possible. If not specified,
%     no optional fields are considered
%
% OUTPUT:
% structC : struct
%     structure with all fields from struct B, plus all or selected fields
%     from structA

if nargin <= 2, fields_to_copy = fields(structA); end
if nargin <= 3, fields_to_copy_opt = {}; end

% Copy all fields of structure B into a new identical structure
structC = struct();
fieldsB = fields(structB);
for ff = 1:length(fieldsB)
    fld = fieldsB{ff};
    structC.(fld) = structB.(fld);
end

% Copy mandatory fields of A into the new structure
for ff = 1:length(fields_to_copy)
    fld = fields_to_copy{ff};
    if uq_isnonemptyfield(structC, fld)
        error('target structure has already field %s', fld)
    else
        structC.(fld) = structA.(fld);
    end
end

% Copy optional fields
for ff = 1:length(fields_to_copy_opt)
    fld = fields_to_copy_opt{ff};
    if uq_isnonemptyfield(structC, fld)
        error('target structure has already field %s', fld)
    elseif isfield(structA, fld)
        structC.(fld) = structA.(fld);
    end
end

