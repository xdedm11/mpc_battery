Up=@(soc,i)26.63*soc^4+3.144*i*soc^3-38.64*soc^3-2.447*i*soc^2+18.2*soc^2+0.3376*i*soc-2.648*soc+0.1093*i+0.9759;
for x=1:9
for y=1:10
uup(x,y)=Up(x/10,y/10);
end
end