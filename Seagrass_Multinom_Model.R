install.packages("devtools")
devtools::install_github("dustinfife/flexplot")
devtools::install_github("lme4/lme4")
install.packages("nlme")
require(flexplot)
require(nlme)
require(tidyverse)

df = read.csv("CSV file containing the cleaned analysis data")

# rename bands/variables
df <- df %>%
  rename(
    B1 = Band_1,
    B2 = Band_2,
    B3 = Band_3,
    B4 = Band_4,
    B5 = Band_5,
    B6 = Band_6,
    B7 = Band_7,
    B8 = Band_8,
    B8A = Band_9,
    B9 = Band_10,
    B11 = Band_11,
    B12 = Band_12,
    ndvi = Band_13,
    fai = Band_14,
    savi = Band_15,
    ndavi = Band_16,
    mndwi = Band_17,
    wavi = Band_18,
    awi = Band_19,
    expmean = Band_20,
    taubmean = Band_21,
    slope = Band_22,
    msg = Band_23,
    cart = Band_24,
    rf = Band_25,
    svm = Band_26,
    knn = Band_27,
    gbt = Band_28,
    cons = Band_29,
    SLOPE = Band_30,
    DEM = Band_31,
    MGS = Band_32,
    SLOPE_2 = Band_33
  )

head(df, 10)

summary(df)

# Pull random sample of pixels 
n = 1000000
set.seed(123) 
sample_indices = sample(nrow(df), n)
sample_df = df[sample_indices, ]

summary(sample_df)

# Recode the data to fit the need of the logistic regression model
sample_df_bin = sample_df %>%
  mutate(cons = case_when(
    cons %in% c(7, 4, 5, 6) ~ NA_real_,
    cons %in% c(1) ~ 1,
    cons %in% c(2, 3) ~ 0,
    TRUE ~ cons
  ))

sample_df_bin = sample_df_bin %>%
  filter(!is.na(cons))

sample_df_bin <- sample_df_bin %>%
  mutate(
    SLOPE_2_sq = SLOPE_2^2,
    MGS_sq = MGS^2,
    DEM_sq = DEM^2
  )

sample_df_bin %>%
  count(cons)

sample_df <- sample_df %>%
  mutate(
    SLOPE_2_sq = SLOPE_2^2,
    MGS_sq = MGS^2,
    DEM_sq = DEM^2
  )

# Simple Log-Models to assess binary seagrass ourtput

flexplot(cons ~ SLOPE_2, data=sample_df_bin, method='logistic', ghost.line = "red")

log_norm_full = glm(cons~SLOPE_2+MGS+DEM+DEM_sq+MGS_sq, data=sample_df_bin, family = binomial)
summary(log_norm_full)
pseudo_r2 <- pR2(log_norm_full)
pseudo_r2

log_norm_red = glm(cons~SLOPE_2+MGS+DEM, data=sample_df_bin, family = binomial)
summary(log_norm_red)
pseudo_r2 <- pR2(log_norm_red)
pseudo_r2

model.comparison(log_norm_full, log_norm_red)


# Full multinominal model to get all classes together

sample_df_mult = sample_df %>%
  mutate(cons = case_when(
    cons %in% c(2, 3) ~ 0,
    TRUE ~ cons
  ))
sample_df_mult$cons <- as.factor(sample_df_mult$cons)
multinom_model <- multinom(cons ~ SLOPE_2 + MGS + DEM + MGS_sq + DEM_sq, data = sample_df_mult)
summary(multinom_model)
pR2m_values <- pR2(multinom_model)
print(pR2m_values)
predictions <- predict(multinom_model, newdata = sample_df_mult)
confusion_matrix <- confusionMatrix(predictions, sample_df_mult$cons)
print(confusion_matrix)

