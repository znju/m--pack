function N_setcontextmenu(cmenu,type)
%N_setcontextmenu
%   is part of NCDView (Matlab GUI for NetCDF visualization)
%
%   MMA 6-2004, martinho@fis.ua.pt
%
%   See also NCDV

% creates uiContextMenu for vector  plots
% type  is overlay (for overlay data) or plot1d (for 1d data plot)

global H

% Define the context menu items

% LineStyle:
cb1 = ['set(gco, ''LineStyle'', ''--'');', ['H.overlay.LineStyle.',type,'=''--'';']  ];
cb2 = ['set(gco, ''LineStyle'', '':'');',  ['H.overlay.LineStyle.',type,'='':'';']   ];
cb3 = ['set(gco, ''LineStyle'', ''-'');',  ['H.overlay.LineStyle.',type,'=''-'';']   ];

line_style = uimenu(cmenu, 'Label', 'LineStyle');
item1 = uimenu(line_style, 'Label', 'dashed', 'Callback', cb1);
item2 = uimenu(line_style, 'Label', 'dotted', 'Callback', cb2);
item3 = uimenu(line_style, 'Label', 'solid', 'Callback', cb3);


% lineWidth
cb1 = ['set(gco, ''LineWidth'', 0.5);', ['H.overlay.LineWidth.',type,'=0.5;']  ];
cb2 = ['set(gco, ''LineWidth'', 1);',   ['H.overlay.LineWidth.',type,'=1;'  ]  ];
cb3 = ['set(gco, ''LineWidth'', 2);',   ['H.overlay.LineWidth.',type,'=2;'  ]  ];
cb4 = ['set(gco, ''LineWidth'', 3);',   ['H.overlay.LineWidth.',type,'=3;'  ]  ];
cb5 = ['set(gco, ''LineWidth'', 4);',   ['H.overlay.LineWidth.',type,'=4;'  ]  ];

line_width = uimenu(cmenu, 'Label', 'LineWidth');
item1 = uimenu(line_width, 'Label', '0.5', 'Callback', cb1);
item2 = uimenu(line_width, 'Label', '1', 'Callback', cb2);
item3 = uimenu(line_width, 'Label', '2', 'Callback', cb3);
item2 = uimenu(line_width, 'Label', '3', 'Callback', cb4);
item3 = uimenu(line_width, 'Label', '4', 'Callback', cb5);

% Color
cb1 = ['set(gco, ''Color'', [1 0 0]);',    ['H.overlay.Color.',type,'=[1 0 0];']  ];
cb2 = ['set(gco, ''Color'', [0 1 0]);',    ['H.overlay.Color.',type,'=[0 1 0];']  ];
cb3 = ['set(gco, ''Color'', [0 0 1]);',    ['H.overlay.Color.',type,'=[0 0 1];']  ];
cb4 = ['set(gco, ''Color'', [0 0 0]);',    ['H.overlay.Color.',type,'=[0 0 0];']  ];
cb5 = ['set(gco, ''Color'', uisetcolor);', ['H.overlay.Color.',type,'=get(gco,''color'');']  ];


color = uimenu(cmenu, 'Label', 'Color');
item1 = uimenu(color, 'Label', 'red',    'Callback', cb1);
item2 = uimenu(color, 'Label', 'green',  'Callback', cb2);
item3 = uimenu(color, 'Label', 'blue',   'Callback', cb3);
item4 = uimenu(color, 'Label', 'black',  'Callback', cb4);
item5 = uimenu(color, 'Label', 'custom', 'Callback', cb5);


% delete
cb1 = ['delete(gco)'];
del = uimenu(cmenu, 'Label', 'clear','callback',cb1);
