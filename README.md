# Progetto elaborazione delle immagini 2019/2020

* Questa applicazione è un ipotetico controllo di qualità del
  confezionamento di scatole di cioccolatini.
* L’applicazione data una fotografia di una scatola di cioccolatini ne valuta la sua
  conformità e ne mostra gli eventuali errori.
* Per questo progetto le uniche scatole di cioccolatini considerate sono le seguenti:
 
![](https://gitlab.com/beppe15/progetto-elaborazione-delle-immagini/uploads/72bd6c4de0328afff35c30a5ed853233/Screenshot_2020-02-22_13-04-49.png)
![](https://gitlab.com/beppe15/progetto-elaborazione-delle-immagini/uploads/c7617b95df26fc7258b057b2d624ff52/Screenshot_2020-02-22_13-04-13.png)

# Una scatola NON è conforme se:

* Mancano dei cioccolatini.
* I cioccolatini sono in posizione non corretta.
* Mancano i bollini sui cioccolatini (esclusivamente i ferrero rocher).
* Ci sono degli elementi estranei nella scatola.
* (La presenza all’esterno della scatola di oggetti NON influenza la conformità della scatola).

# Risultato classificazione
![](https://gitlab.com/beppe15/progetto-elaborazione-delle-immagini/uploads/6e164e1369bdae3b5ffce3be60c564e6/Screenshot_2020-02-22_13-33-20.png)
![](https://gitlab.com/beppe15/progetto-elaborazione-delle-immagini/uploads/8216a5f373493a61598361ec02b9bdea/Screenshot_2020-02-22_13-34-02.png)


# Visualizzazione eventuali errori
![](https://gitlab.com/beppe15/progetto-elaborazione-delle-immagini/uploads/055a150155b3e1bf9d0c65d219fe9b24/Screenshot_2020-02-22_13-33-42.png)

# Implementazione Matlab

* main.m - contiene la funzione che data un immagine ritorna la conformità.
* maintest.m - valuta la conformità di tutte le immagini.
* +classification - contiene una serie di script e funzioni per la classificazione.
* +utils - funzioni utili (comprese quelle oer il calcolo delle features).
* +classification/trainchoco.m e +classification/trainshape.m - eseguono il training dei classificatori e la valutazione (matrice di confuzione).
