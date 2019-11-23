# tmmt-poc
TMMT Proof of Concept

The goal is to take a large business domain model and a complex template( from Maxim) and reproduce the outputs using 
a set of very small simple set of processes. 


Essentially 4 phases

Text->Model  Model->Model  Model->Text Text->File

## Multi-language?
While the first version will be Dart for lazyness and platform independence, I am hoping that if it is less than 2kloc then I can migrate it to TypeScript or JavaScript. There is also the option of putting a Flutter front-end on.

## Build Integration
I am currently very torn about short-hop and long-hop transformation. I think that the proof-of-concept will need to do a naive implementation of both to help with the decision.