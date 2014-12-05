function B_regions = nbt_compare_getRegions(B,regions) 
%         figure
        for i = 1:length(regions);
            chans_in_reg = regions(i).reg.channel_nr;
%             subplot(1,length(regions),i)
%             hist(B(chans_in_reg))
            B_regions(i) = nanmedian(B(chans_in_reg));
%             hold on
%             plot(B_regions(i),20,'r*')
        end
    end