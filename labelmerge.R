# script to merge all the label csv files into the right format

library(tidyverse)
library(stringr)

label_dir <- 'labels/'

all <- lapply(paste0(label_dir, list.files(label_dir)),
       function(a) {
         temp <- read_csv(a, col_types = paste0('i', paste0(rep('d', 21), collapse = ""))) %>% as.data.frame()
         colnames(temp) <- str_replace_all(colnames(temp), " ", "_")
         
         tags <- sapply(1:nrow(temp), function(a) {
           paste(colnames(temp[, -1])[temp[a, -1] > 0], collapse = " ")
         })
         
         temp %>% 
           mutate(image_name = paste('train', str_extract(a, "[0-9]+"), "frame", Frame, sep = "_"),
                  tags = tags) %>% 
           select(image_name, tags)
       }
)

all <- do.call("rbind", all)

write_csv(all, 'train_tags.csv')

