function S_about
%function S_about
%displays information about SpectrHA
%
%this function is part of SpectrHA utility
%MMA, Jul-2003
%martinho@fis.ua.pt

global LOOK INFO

s1=INFO.label;
s2=INFO.title;
s3=['Created by ',INFO.author];
s4=INFO.address;
s5=INFO.version;
s6=INFO.www;
s7=INFO.email;
s=strvcat(s1,s2,s3,' ',s4,' ',s5,s6,s7);
str=['about ',INFO.label];
h=helpdlg(s,str);
%%set(h,'color',LOOK.color.bg);
