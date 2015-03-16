function nbt_topoplotConnect(NBTstudy,connMatrix,threshold)
    chanLocs = NBTstudy.groups{1}.chanLocs;
    
    %%% Draw the empty topoplot
    topoplot([],chanLocs,'headrad','rim','maplimits',[-3 3],'style','map','numcontour',0,'electrodes','on','circgrid',100,'gridscale',32,'shading','flat');
    set(gca, 'LooseInset', get(gca,'TightInset'));

    hold on

    %threshold = 0.995;

    % Number of channels
    nChannels = size(connMatrix,1);
    % 
    Red_cbrewer5colors = load('Red_cbrewer5colors','Red_cbrewer5colors');
    Red_cbrewer5colors = Red_cbrewer5colors.Red_cbrewer5colors;
    colormap(Red_cbrewer5colors);

        % Plotting properties for topoplot.m
        rmax = 0.5;
        plotrad = 0.8011;

        for i = 1 : nChannels
            Th(i) = chanLocs(i).theta;
            Rd(i) = chanLocs(i).radius;
        end
        Th = pi/180*Th;

        [x,y]     = pol2cart(Th,Rd);

        % Transform electrode locations from polar to cartesian coordinates


    squeezefac = rmax/plotrad;
    Rd = Rd*squeezefac;       % squeeze electrode arc_lengths towards the vertex
                              % to plot all inside the head cartoon


    x    = x*squeezefac;
    y    = y*squeezefac;

    cmin = threshold;
    cmax = max(connMatrix(:)<0.99);

    colorStep = (cmax-cmin)/5;

    for i = 1 : nChannels
        for j = i : nChannels
            if (connMatrix(i,j) > threshold & connMatrix(i,j) < 0.99)
                color = floor((cmax-connMatrix(i,j)) / colorStep)+1;
                plot3([y(i) y(j)],[x(i) x(j)], [ones(size(x(i))) ones(size(x(i)))],'LineWidth',2,'color',Red_cbrewer5colors(color,:));
            end
        end
    end
end