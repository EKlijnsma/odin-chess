# The Odin Project - Chess
For details on the assignment refer to the [Ruby Final Project page](https://www.theodinproject.com/lessons/ruby-ruby-final-project)  
For general information on The Odin Project refer to the [Homepage](https://www.theodinproject.com/)

## Project description
The assignment is fairly straightforward: 
> Build a command line Chess game where two players can play against each other.
>
> The game should be properly constrained – it should prevent players from making illegal moves and declare check or check mate in the correct situations.
>
> Make it so you can save the board at any time.

Simple enough right?

It did not take me too long to realize that this requires a structured approach and a thorough management of files, methods, separation of concerns, and so on. 


## How to install
To do

## How to use
To do

## Reflection
This project was a really bumpy ride.

### The first try
The first time I started working on this project was late august 2024. I did not blindly dive into the project, but thoroughly thought about the structure. What classes to define, what their responsibilities would be, what the game logic should be, etc. 
I also play chess every now and then so I did not have to learn the rules anymore. That also means I recognized some challenges early on. 
- How to determine if castling is allowed?
- How to determine if en passant is allowed?
- What about pinned pieces?
- What about stalemate?
- What about repetition of moves?
- What about pawn promotion?

After spending a good amount of time thinking about the flow, dependencies and actually trying to draw it out using flowcharts and what not, I started coding. 

I had my struggles of course but generally speaking it all went fairly well. I had a game where the basics seemed to be working. Players could make moves. Pieces would not move outside the board, the would not be able to jump past other pieces (except for the knight), etc.

Next up was implementing logic concerning checks and checkmates. How to determine this? How to take that into consideration when trying to move pinned pieces (pieces that cant move because that would put your own king in check). 

This was a topic that kept me on a plateau for a while. 
And then life got in the way. 

I got so busy with other things that I could not find the time to work on this project anymore and left it unattended for about 9 or 10 months. 

### The second try
Finally, in June 2025, I had some time again and felt energized enough to get back to it. Revisit some old code to get familiarized with Ruby syntax again, and with coding logic in general. And then revisit the project as I left it 9 or 10 months ealier.

Status?  
Different approach?  
Separation of concerns?  

### Key takeaways

## Author

Github: [EKlijnsma](https://github.com/EKlijnsma)  
LinkedIn: [emielklijnsma](https://www.linkedin.com/in/emielklijnsma/)
