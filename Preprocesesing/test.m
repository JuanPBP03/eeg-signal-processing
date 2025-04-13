f = obj.samplerate/obj.samples*(0:obj.samples-1);
rawFFT = obj.normFFT;
raw = obj.Data;
badIDx = find(f>49 & f<51);
chpass = squeeze(rawFFT(:,badIDx,:)<0.01);
subpass = all(chpass==1,[2 ]);