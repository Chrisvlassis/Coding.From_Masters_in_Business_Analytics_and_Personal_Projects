# αυτα απαντηθηκαν: 
# ερωτηση 1: το AIC που μας δινει δεν θα επρεπε να χρησιμοποιειται για την μεταξυ συγκριση των μοντελων      YES  

# ερωτηση 2: γιατι Residual deviance: 1258.7 / 2668  degrees of freedom θελω να ειναι κοντα στο 1            ΑΣΤΟ 

# ερωτηση 3: γιατι στο μοντελο εχω υψηλα pseudo R squares αλλα οχι καλα Hosmer-Lemeshow Test ΕΧΩ ΚΑΛΟ, null: has a good fit  

# ερωτηση 6: τι καταλαβαινω απο τα διαγραμματα: pearson residuals VS fitter value OR independent variable, 
# αν δω pattern τοτε πρεπει να κανω καποια αλλαγη. Transformation 

# ερωτηση 7: βοηθαει ο BIC στο να λυσουμε multicoliniarity issues                     ΟΧΙ 

##################################################################################################################################
# ερωτηση 5: θελω Linearity μεταξυ των log odds και των ανεξαρτητων μεταβλητων? αυτο ειναι assumption, σωστα?

# ερωτηση 4: ειναι assumption στο logistic regression το 'να μην υπαρχουν outlires'? 

# ερωτηση 6: τι καταλαβαινω απο τα διαγραμματα: pearson residuals VS fitter value OR independent variable, 
# αν δω pattern τοτε πρεπει να κανω καποια αλλαγη. Transformation 

summary(model_lol)

summary(model_BIC_state)
