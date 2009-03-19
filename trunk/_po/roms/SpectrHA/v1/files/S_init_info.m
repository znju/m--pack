function S_init_info
%function S_init_info
%Sets many data related with version, site, etc
%
%this function is part of SpectrHA utility
%MMA, Jul-2003
%martinho@fis.ua.pt

global INFO

label='SpectrHA';
title='Spectral Harmonic Analysis of series';
version='v 1, Jul 2003, v 2, Jun 2004';
author='Martinho Marta Almeida';
email='martinho@fis.ua.pt';
address=strvcat('Physics Department',...
                'Aveiro University',...
                'Portugal');
www='http://neptuno.fis.ua.pt/~mma/SpectrHA';

%---------------------------------------------------------------------
INFO.label=label;
INFO.title=title;
INFO.version=version;
INFO.author=author;
INFO.email=email;
INFO.address=address;
INFO.www=www;
