import scipy as scp
import pandas as pd
import numpy as np
import matplotlib.pyplot as plt


arquivo_dat = "Dados_Do_Campo_Elétrico.dat"
data_frame = pd.read_csv(arquivo_dat, delim_whitespace=True)
print(data_frame.shape)
data_frame.to_csv("Dados_Em_CSV", index = False)

n_vet = 125
#Tratando os dados de tempo
#----------------------------------------------------------------------
for inicio in range(0,len(data_frame), n_vet):
    final = min(inicio + n_vet, len(data_frame))
    media = data_frame.loc[inicio:final,"Tempo(s)"].mean()
    data_frame.loc[inicio:final] = media
print("Média a cada 125 vetores")
print(data_frame["Tempo(s)"])
#-----------------------------------------------------------------------



#Trazendo a lista de posições de cada vetor respectivo
t = data_frame["Tempo(s)"] #Lista dos instantes de tempo

subset = data_frame[data_frame["Tempo(s)"] == data_frame.loc[124, "Tempo(s)"]]
#-----------------------------------------------------------------------
print(subset)
#


#havia criado o plot aqui mas apaguei mais de uma vez devido a organização e achar os erros