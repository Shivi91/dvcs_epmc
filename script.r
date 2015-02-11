# functions stored in zzz.R

source(file = "R/zzz.R")

# base urls to hosting services
dvcs <- c("code.google.com", "github.com", "sourceforge.net", "bitbucket.org")
# queried through epmc
tt <- lapply(dvcs, epmc_search, limit = 10000)
tt.df <- dplyr::bind_rows(lapply(tt, "[[", "data"))
hits <- sapply(tt, "[[", "hits")
tt.df$dvcs <- rep(dvcs, times = hits)
write.csv(tt.df,"data/dvcs_epmc_md.csv")

# fetch dvcs repos from epmc oa fulltexts

my.df <- read.csv("data/dvcs_epmc_md.csv", header = TRUE , sep = ",")
my.epmc <- my.df[!is.na(my.df$pmcid),]

pmcid_dvcs <- ldply(my.epmc$pmcid, tst, dvcs)

# remove duplicated entries
pmcid_dvcs <- pmcid_dvcs[!duplicated(pmcid_dvcs),]
write.csv(pmcid_dvcs, "data/pmcid_dvcs.csv")
