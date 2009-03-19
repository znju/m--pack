function S_restore_txt
%function S_restore_txt
%Restore txt_head string
%In PCWIN this string can only be viewed with keyboard direction
%buttons, only if type is 'edit';
%so, after edit showld be restored.
%In UNIX, type can be text, no problem
%global var which stores this string is ETC.txt_head
%
%%this function is part of SpectrHA utility
%MMA, Jul-2003
%martinho@fis.ua.pt

global HANDLES ETC

set(HANDLES.txt_head,'string',ETC.txt_head);
