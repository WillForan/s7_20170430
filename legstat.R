library(dplyr)
library(fields) # calcuate distance w/ rdist.earth

d<-read.table('path_alt.txt') 
names(d) <- c('leg','type','lat','long','alt')

d.sum <-
 d %>% 
 mutate(   runner=ifelse(leg%%7==0,7,leg%%7) ) %>%
 group_by(leg,runner) %>% 
 mutate(deltalt=c(0,diff(alt))) %>%
 summarise(
    altup=sum(deltalt[deltalt>0]),
    altdown=sum(deltalt[deltalt<0]),
    altnet=sum(deltalt),
    dist= 
      rdist.earth.vec(
        matrix(c(lead(long),lead(lat)),ncol=2),
        matrix(c(long,lat),ncol=2) ) %>%
      sum(na.rm=T) %>%
      round(2)
 ) %>% 
 ungroup %>%
 mutate(runno=ceiling(leg/max(runner)) %>% factor,
        distnomean=dist-mean(dist),
        altupnomean=altup-mean(altup) )

dist_mean <- mean(d.sum$dist) %>% round(2)
plottitle <- sprintf('distance from average leg by runner (avg = %.02f mi)',dist_mean)

p <- 
 d.sum %>% mutate(runner=factor(runner)) %>%
 ggplot() +
 aes(x=runner,y=distnomean,group=leg,fill=runno) + 
 geom_col() +
 theme_bw() +
 ggtitle(plottitle)

ggsave(p,file='dist_from_avg_s7.png')
write.table(file='legs.csv',d.sum,quote=F,row.names=F,sep=",")
