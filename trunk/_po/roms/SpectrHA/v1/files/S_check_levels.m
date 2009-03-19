function S_check_levels
%function S_check_levels
%Set number of s-levels to choose according with selected variable
%
%this function is part of SpectrHA utility
%MMA, Jul-2003
%martinho@fis.ua.pt

global HANDLES FSTA

variavel = get(HANDLES.vars,'value');

if S_isserie
    if variavel == 1 | variavel == 2 | variavel == 3 % zeta, Ubar or Vbar
        set(HANDLES.vlevels,'value',1,'string','1'); % one field only.
    else
        if ~isempty(FSTA.nlevels)
            set(HANDLES.vlevels,'string',int2str([1:FSTA.nlevels]'));
        else
            set(HANDLES.vlevels,'string',int2str(1));
        end
    end
    
else % ellipse
    if variavel == 1 %U&Vbar
        set(HANDLES.vlevels,'value',1,'string','1'); % one field only.
    else
        if ~isempty(FSTA.nlevels)
            set(HANDLES.vlevels,'string',int2str([1:FSTA.nlevels]'));
        else
            set(HANDLES.vlevels,'string',int2str(1));
        end
    end
end
return


