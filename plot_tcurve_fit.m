% Function to plot the transfer curve with the mobility fit based on the
% output of one of the mobility_map functions

function [ax, ax2] = plot_tcurve_fit(dd,devNums,type)
%type = 'p' or 'n' based on the device type

if abs(dd(devNums).vt) > 1000
    fprintf('SD Short - Cannot plot for dev #%i \n',devNums);
else
    f=figure;
    ax=gca;
    hold(ax,'on')
    
    for d = devNums
        
        fit = dd(d).fit_fun;
        
        vg = dd(d).vg;
        id = dd(d).id;
        
        ax2 = plotyy(vg,sqrt(abs(id)),vg,abs(id),'plot','semilogy');
        if type == 'n'
            fplot(ax,@(x) sqrt(-fit(x)),[dd(d).vt,max(vg)],'--k','LineWidth',1);
        elseif type == 'p'
            fplot(ax,@(x) sqrt(-fit(x)),[min(vg),dd(d).vt],'--k','LineWidth',1);
        end
    end
    
    ax.FontSize = 14;
    ax.Box = 'on';
    ax.LineWidth = 1;
    f.Position = [770 355 700 500];
    ax.Position = [0.15 0.15 0.7 0.8];
    
    xlabel('Gate Voltage (Volts)')
    ylabel(ax2(1),'(Drain Current)^{1/2} (A^{1/2})')
    ylabel(ax2(2),'Drain Current (A)')
    
    lin_bounds = [0, round(max(sqrt(abs(id)))*1.1,2,'significant')];
    log_bounds = [10^floor(log10(min(abs(id)))), 10^ceil(log10(max(abs(id))))];
    %disp(log_bounds)
    set(ax2(1),'YLim',lin_bounds);
    set(ax2(1),'ytick',linspace(lin_bounds(1),lin_bounds(2),5));
    set(ax2(2),'YLim',log_bounds);
    if min(abs(id))==0
        set(ax2(2),'ytick',10.^(floor(log10(min(abs(id))+1E-10)):ceil(log10(max(abs(id))))));
    else
        set(ax2(2),'ytick',10.^(floor(log10(min(abs(id)))):ceil(log10(max(abs(id))))));
    end
    ytl = {};
    for i = 1:length(ax2(2).YTick)
        ytl{i} = num2str(ax2(2).YTick(i));
    end
    set(ax2(2),'yticklabels',ytl);
    set(ax2(2),'FontSize',14);
    set(ax2(2),'LineWidth',1);
    ax.Children(2).LineWidth=1;
    ax2(2).Children(1).LineWidth=1;
end

end