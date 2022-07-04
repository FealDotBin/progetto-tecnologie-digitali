# progetto-tecnologie-digitali
## Scopo del progetto
Realizzare il controllore di un sistema di inscatolamento. Su un nastro trasportatore
circolare arrivano casualmente oggetti da 1Kg e da 2Kg. Il sistema deve prendere gli
oggetti e riempire totalmente delle scatole che possono contenere oggetti per 4Kg. Gli
oggetti vengono messi dentro le scatole, se c’è posto, da un braccio meccanico. Quando
la scatola è piena viene rimossa dal sistema attraverso un altro braccio meccanico
differente dal precedente, ponendole su un pallet. L’automa ogni volta che si presenta
un oggetto sul nastro deve decidere se metterlo nella scatola perché c’è ancora posto ed
anche se rimuovere la scatola perché piena (dopo aver inserito l’oggetto). Dopo che il
secondo braccio ha spostato 10 scatole, attiva una sirena che indica all’operatore di
dover rimuovere il pallet. Fintanto che l’operatore non ha rimosso il pallet contente le
scatole, i bracci non possono muovere altri oggetti e scatole.
