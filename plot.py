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
print("Média a cada 125 vetores")
#----------------------------------------------------------------------

U = data_frame.loc[inicio:final, "Coordenada_U(m)"]
V = data_frame.loc[inicio:final, "Coordenada_V(m)"]
W = data_frame.loc[inicio:final, "Coordenada_W(m)"]
#     #Coordenadas dos vetores
X = data_frame.loc[inicio:final, "Coordenada_X(m)"]
Y = data_frame.loc[inicio:final, "Coordenada_Y(m)"]
Z = data_frame.loc[inicio:final, "Coordenada_Z(m)"]


for i in range(125):
      v = [X.iloc[i],Y.iloc[i],Z.iloc[i]]
      v = normaliza_vetor(v)
      velocidade = [x*velocidade[0], y*velocidade[1],z*velocidade[2]]
      x = v[0]
      y = v[1]
      z = v[2]
      A = velocidade/(c * np.linalg.norm(v))
      B = curl(A)
      ax.quiver(U.iloc[i],V.iloc[i],W.iloc[i],v[0],v[1],v[2], pivot = 'middle', color = 'green')
      #ax.quiver(U.iloc[i],V.iloc[i],W.iloc[i], B[0],B[1],B[2], pivot = 'middle', color = 'red')
print(B)
plt.show()
#-----------------------------------------------------------------------
