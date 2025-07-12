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

## How to install
To do

## How to use
To do

## Reflection
This project was a really bumpy ride for me. Partially because it the assignment page was right in stating that:
> This is the largest program that you’ve written, 
> so you’ll definitely start to see the benefits of good organization 
> (and testing) when you start running into bugs.

And also partially because life got very very busy which made me lay this project to rest for about 10 months.

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
At around the same time life got so busy that I could not find the time to work on this project anymore and left it for about 9 or 10 months. 

### The second try
Finally, in June 2025, I had some time again and felt energized enough to get back to it. I revisited some old code to get familiarized with Ruby syntax again, and with coding logic in general. And then revisit the project as I left it 9 or 10 months ealier.

I made the conscious decision to start fresh again, for a couple of reasons:
- It would mean I had to code more stuff which would help getting to know the Ruby syntax again
- It would have the potential benefit of making better design choices along the way
- I would still have the "first try code" on the side to see how I though about it before.

Already in the first days I noticed that I made some major design decisions differently.  
My old solution had things prettty tangled up. The board knows the postion of the pieces, but each piece also knew its position for example. 
Obviously this could lead to inconsistencies as there would not be a single source of truth. 

Other examples would be that the board instance was present in both the game and the piece classes.
Or that the player class would take care of all movement validation as well (meaning it has knowledge of the board state)
This may be part of the reason why it got unclear to me last time what information would be stored and requested from which class. 

This time I feel like I took a much cleaner approach. 
- The player class now just takes input from the player. The only validation it does is concerning input format, is the input an actual square on the board? 
- A piece will know all its possible moves regardless of the board state. For example the knight has 8 possible moves (L-shaped) and this will be part of the move validation.
- Next steps in move validation will be handled by the board class (moving out of bounds, or to squares occupied by own pieces for example), or the game class (prevent castling when the king already moved for example)

Especially the approach for move validation was a big foggy grey area for me last time. 
Where in this second attempt I simply went over all possible restrictions and implemented them 1 by 1.
I feel like I had a much cleaner approach in simply dividing everything up into methods that do 1 thing (as much as possible). 
That also meant I could re-use methods later for different purposes.

One deliberate decision I made was to not refactor or restructure the code too much while working on it.
The first aim would be to make it work, after that I would do the housekeeping.

When I had the game working I had too much responsibility and functionality especially within the Board class. A lot of it had to do with validating if a move is legal, so I moved this into a separate MoveValidator class. Later I also created a MoveGenerator and MoveExecuter class. 

Although it feels very vulnerable to move stuff around and I felt like completely breaking my code, it was quite easy to fix some minor bugs that were introduced. The code felt a lot cleaner now. 

It also clicked much more now how the separations could be handled and it was the first time I used more abstract classes like MoveValidator and MoveExecuter that are not reflecting a physical thing like a piece or a board. 


### Key takeaways
Overall I am very happy that I came back to this project instead of bailing out and starting another course. 
The psychological victory of conquering this project relatively quickly after a long period of being away from coding altogether is really rewarding. 

The decision to start from scratch with the old code on the side was also the right one. I think it helped me to rethink the program mechanics from a more abstract position before diving back into the code and the syntax again. 

The main thing I have learned from this project, and especially when comparing the 2 efforts it took is the benefit of keeping classes and methods simple and responsible for 1 core thing. 
I think it can not be overestimated how important separation of concerns is and how much it helps to tackle big challenges. 

One thing I did not do as much as I would like is write tests while implementing solutions. 
Every now and then I forgot to test my methods and got into a situation where I implemented a lot of stuff already without proper testing. 
Luckily this did not result in lenghty debugging sessions, but a note to myself would be to get into the habit working small pieces of the program at the time. 
Same with git, I did not really make 'atomic commits' all the time. So that is a learning curve for me: small changes or implementations -> testing -> committing.

Either way, this second take did revitalize my journey to coding and I am looking forward to completing the entire curriculum and build full stack ruby on rails projects!

## Author

Github: [EKlijnsma](https://github.com/EKlijnsma)  
LinkedIn: [emielklijnsma](https://www.linkedin.com/in/emielklijnsma/)
