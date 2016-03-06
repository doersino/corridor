% ENGINE %
:- include('read.pl').

% terminating and rstarting the program 
corridor([r]) :- corridor([restart]).
corridor([q]) :- corridor([quit]).
corridor([restart]) :- consult(corridor), corridor, !.
corridor([quit]) :- !.

% fix for empty input
corridor([]) :-
	write('> '),
	read_sentence(Input1),
	corridor(Input1),
	!.

% do stuff, commandcount++, read new input
corridor(Input) :-
	do(Input),
	commandcount_add(1),
	nl,
	write('> '),
	read_sentence(Input1),
	corridor(Input1),
	!.

% count commands
commandcount_add(X) :-
	commandcount(Old),
	New is Old + X,
	retract(commandcount(_)),
	assert(commandcount(New)).

% change location
location_change(X) :-
	retract(location(_)),
	assert(location(X)).

% change room and change location to room
location_change(room,X) :-
	retract(room(_)),
	assert(room(X)),
	location_change(room).

roomtests(X) :-
	location(outside),
		w('You need to be in the building in order to enter a room.');
	(location(room), not(room(X))),
		w('You need to leave this room before entering another room.');
	(location(room), room(X)),
		w('You\'re already in that room.').

% make printing text to the console less of a pain in the bum
w([]).
w([H|T]) :- writeln(H), w(T).
w(X) :- writeln(X).


% DYNAMICS %
:- abolish(location/1).
:- dynamic location/1.
location(outside).

:- abolish(commandcount/1).
:- dynamic commandcount/1.
commandcount(-1).

:- abolish(room/1).
:- dynamic room/1.
room(0).

:- abolish(key1/1).
:- dynamic key1/1.
key1(false).

:- abolish(key2/1).
:- dynamic key2/1.
key2(false).

:- abolish(cube/1).
:- dynamic cube/1.
cube(false).


% BEGIN %
corridor :- corridor([f48hdg750pmsn1467c4b6]). % randomly generated name to prevent accidential use


% ALIASES % (sadly, some other aliases need to be buried in the code to work well)
do([leave|X]) :- do([exit|X]).
%do([step,out,of|X]) :- do([exit|X]).
%do([go,out,of|X]) :- do([exit|X]).
%do([step,into|X]) :- do([enter|X]).
%do([go,to|X]) :- do([enter|X]).
do([open,door,X]) :- do([enter,room,X]).
do([open,X,door]) :- do([enter,X,room]).

%do([c]) :- commandcount(X), w(X).

% COMMANDS %
do([f48hdg750pmsn1467c4b6]) :-
	w([
		'',
		'',
		'                          CORRIDOR',
		'',
		'A slightly eerie single-player text adventure. Please make',
		'sure that your console window is at least 60 charcters wide.',
		'Type "help" to get a (incomplete) list of commands, or type',
		'"quit" to terminate the program. Have fun!',
		'',
		'                             ~~',
		'',
		'You\'ve always been curious as to what this industrial',
		'building contains. About 15 meters wide, 50 long, and 7',
		'tall at its ridge, it\'s the only abandoned building in the',
		'town you\'ve been living in since you were born. You\'re',
		'twenty now. When you were a kid, you spent your school',
		'breaks exploring its surroundings. As a teenager, you and',
		'your friends have spent many warm summer evenings sitting',
		'and talking and drinking beer in the hayfield around it.',
		'',
		'Most of your friends are off to college now, or they\'re',
		'traveling the world. Their lives have changed, and so has',
		'the building. Its metal front door, which had always been',
		'hidden beneath a layer of boards, is standing wide open now',
		'- almost as if it\'s been expecting you. And some of the',
		'small windows (there are ten on each of the long sides of',
		'the building), which had been nailed shut as well, reveal',
		'their shattered glass.',
		'',
		'You consider entering the industrial building.'
	]).

do([help]) :-
	% happily puke some of the commands to the console
	w([
		'quit - terminates the program',
		'restart - terminates the program, recompiles it, and starts',
		'          it again',
		'location OR where am i - outputs the current location',
		'use X',
		'enter X',
		'enter room X (e.g. X = 17 or X = seventeen)',
		'enter X room (e.g X = seventeenth)',
		'leave X OR exit X',
		'leave room X OR exit room X (e.g. X = 17 or X = seventeen)',
		'leave X room OR exit X room (e.g. X = seventeenth)',
		'go home - end the game by going home',
		'',
		'This list is incomlete: There are quite a few more commands',
		'that you can use in some of the rooms.'
	]).

do([where,am,i]) :- do([location]).
do([location]) :-
	location(outside),
		w('You\'re standing in front of the industrial building.');
	location(building),
		w('You\'re standing in the corridor inside the building.');
	location(room),
		(room(14),
			w('You\'re currently staring into the bottomless pit in room 14.');
		room(X),
			write('You\'re currently in room '),
			write(X),
			w('.'));
	location('bottomless pit'),
		w([
			'Your body is still falling down the bottomless pit in the',
			'fourteenth room.'
		]);
	location(home),
		w('You\'re at home.').

do(_) :-
	location('bottomless pit'),
		w([
			'You have died by jumping into the bottomless pit in the',
			'fourteenth room. Type "quit" to terminate the program, or',
			'type "restart" to play again.'
		]).

do([use,the,cube]) :- do([solve,cube]).
do([use,the,'rubik\'s',cube]) :- do([solve,cube]).
do([use,'rubik\'s',cube]) :- do([solve,cube]).
do([use,cube]) :- do([solve,cube]).
do([solve,the,'rubik\'s',cube]) :- do([solve,cube]).
do([solve,'rubik\'s',cube]) :- do([solve,cube]).
do([solve,the,cube]) :- do([solve,cube]).
do([solve,the,'rubik\'s',cube]) :- do([solve,cube]).
do([solve,'rubik\'s',cube]) :- do([solve,cube]).
do([solve,cube]) :-
	cube(true),
	w([
		'You solve the Rubik\'s Cube that you found in the nineteenth',
		'room of the industrial building, which doesn\'t take a lot of',
		'time and effort - it was one of your hobbies when you were',
		'younger. After successfully solving it, you shuffle the',
		'Rubik\'s Cube again.'
	]).

do(_) :-
	location(home),
		w([
			'You have finished the game by going home. Type "quit" to',
			'terminate the program, or type "restart" to play again.'
		]).

do([enter,industrial,building]) :- do([enter,building]).
do([enter,building]) :-
	location(outside),
		w([
			'You enter the building.',
			'',
			'You stand in a corridor which appears to stretch across the',
			'entire building. It\'s about 3 meters wide and as high as',
			'the building itself. A few small holes in the roof allow',
			'thin rays of light to illuminate the surprisingly clean',
			'looking floor and walls, though it\'s hardly bright enough',
			'for you to make out any details. Luckily you\'ve brought a',
			'flashlight, which you swiftly switch on.',
			'',
			'The beam of light falls on a door in the left wall of the',
			'corridor. It looks fairly old, as if it was made about a',
			'century ago, and there\'s a metal door plate on it.',
			'',
			'You take a step forward to read the door plate. A single',
			'word is inscribed on it. "ONE." You turn around, expecting',
			'your flashlight to illuminate another door. Sure enough,',
			'there is one. It looks a little more modern that the first',
			'door, and next to this door, there\'s a paper label on which',
			'the word "TWENTY" is printed.',
			'',
			'Walking down the corridor, you see eighteen more doors of',
			'varying age and design. You can\'t recognize a system',
			'behind the distribution of these doors: some of them look',
			'like they survived a few centuries, while others appear to',
			'be brand-new. Seven of them - door three through five, door',
			'eight, door sixteen, door eighteen, and door nineteen - are',
			'nailed shut, akin to many of the windows you had seen from',
			'the outside.',
			'',
			'You consider entering one of the rooms that are doubtlessly',
			'hidden behind the doors.'
		]),
		location_change(building);
	w('You\'re already inside the building.').

do([exit,building]) :-
	location(building),
%		commandcount(X),
%		(X > 9, % count commands; few commands -> player should explore more	!!!!%-- MAYBE REMOVE
%			w([
%				'You leave the building. It feels somewhat strange to be in',
%				'the real world again. Then again, what does "real" mean,',
%				'really? Your experiences inside felt just as real as this.',
%				'',
%				'You consider going home.'
%			]);
%		X < 10,
%			w('You leave the building.')),
		w([
			'You leave the building. It feels somewhat strange to be in',
			'the real world again. Then again, what does "real" mean,',
			'really? Your experiences inside felt just as real as this.',
			'',
			'You consider going home.'
		]),
		location_change(outside);
	location(room),
		w('You need to leave this room before leaving the building.');
	w('You\'re not inside the building.').

do([enter,room]) :-
	location(building),
		w('You need to decide which room you want to enter.');
	w('You need to be in the building in order to enter a room.').

do([enter,room,X]) :-
	(X = '1'; X = one),
		do([enter,first,room]);
	(X = '2'; X = two),
		do([enter,second,room]);
	(X = '3'; X = three),
		do([enter,third,room]);
	(X = '4'; X = four),
		do([enter,fourth,room]);
	(X = '5'; X = five),
		do([enter,fifth,room]);
	(X = '6'; X = six),
		do([enter,sixth,room]);
	(X = '7'; X = seven),
		do([enter,seventh,room]);
	(X = '8'; X = eight),
		do([enter,eighth,room]);
	(X = '9'; X = nine),
		do([enter,ninth,room]);
	(X = '10'; X = ten),
		do([enter,tenth,room]);
	(X = '11'; X = eleven),
		do([enter,eleventh,room]);
	(X = '12'; X = twelve),
		do([enter,twelfth,room]);
	(X = '13'; X = thirteen),
		do([enter,thirteenth,room]);
	(X = '14'; X = fourteen),
		do([enter,fourteenth,room]);
	(X = '15'; X = fifteen),
		do([enter,fifteenth,room]);
	(X = '16'; X = sixteen),
		do([enter,sixteenth,room]);
	(X = '17'; X = seventeen),
		do([enter,seventeenth,room]);
	(X = '18'; X = eighteen),
		do([enter,eighteenth,room]);
	(X = '19'; X = nineteen),
		do([enter,nineteenth,room]);
	(X = '20'; X = twenty),
		do([enter,twentieth,room]);
	location(building),
		w('You can\'t enter a room that doesn\'t exist.');
	w('You need to be in the building in order to enter a room.').

do([enter,first,room]) :-
	location(building),
	key1(true),
		w([
			'You try to open the door to the first room, but it doesn\'t',
			'seem to move at all. Luckily, you\'ve found a key which seems',
			'to match this door\'s design in the second room. You put this',
			'key in the door lock, anxiously turn it twice, turn the door',
			'handle, pull - and the door squeakily swings open.',
			'',
			'At first, you think that the first room of the building',
			'extends endlessly into the darkness. After aiming your',
			'flashlight towards the general direction of "forward", you',
			'absolutely know that this room extends further than it',
			'should, given the physical dimensions of the building. The',
			'floor, the ceiling, and the walls to both sides appear to',
			'adhere to the laws of physics, so you enter the room and',
			'walk a few steps. You still see nothing but the cone of',
			'light that your flashlight casts in front of you, and',
			'continue advancing deeper and deeper into the room, which',
			'has sort of become another cooridor, though there are no',
			'doors, and no windows, there\'s just the giant tube that is',
			'the room.',
			'',
			'Ater a while, you begin to consider returning to the door',
			'and leaving this room.'
		]),
		location_change(room,1);
	location(building),
		w([
			'You try to open the door to the first room, but it doesn\'t',
			'seem to move at all. However, a keyhole sits in the middle',
			'of the door - maybe a matching key is hidden in one of the',
			'other rooms.'
		]);
	roomtests(1).

	do([continue,walking]) :- do([continue]).
	do([continue,walking,into,the,room]) :- do([continue]).
	do([continue,walking,into,room]) :- do([continue]).
	do(['don\'t',return]) :- do([continue]).
	do(['don\'t',return,to,the,door]) :- do([continue]).
	do(['don\'t',return,to,door]) :- do([continue]).
	do(['don\'t',return,to,the,door,and,leave,this,room]) :- do([continue]).
	do(['don\'t',return,to,door,and,leave,this,room]) :- do([continue]).
	do(['don\'t',return,to,the,door,and,leave,the,room]) :- do([continue]).
	do(['don\'t',return,to,door,and,leave,the,room]) :- do([continue]).
	do(['don\'t',return,to,the,door,and,leave,room]) :- do([continue]).
	do(['don\'t',return,to,door,and,leave,room]) :- do([continue]).
	do(['don\'t',leave]) :- do([continue]).
	do(['don\'t',leave,this,room]) :- do([continue]).
	do(['don\'t',leave,the,room]) :- do([continue]).
	do(['don\'t',leave,room]) :- do([continue]).
	do([continue]) :-
		location(room),
		room(1),
		w([
			'You continue walking towards the end of the first room - if',
			'there is an end, that is. After a few minutes, you feel like',
			'the temperature is beginning to fall slowly.',
			'',
			'However, after walking for what seems like a long time, but',
			'probably has only been a couple more minutes, it\'s getting',
			'warmer again.'
		]).

	do([return]) :- room(1), do([exit,room]).
	do([return,to,the,door]) :- room(1), do([exit,room]).
	do([return,to,door]) :- room(1), do([exit,room]).
	do([return,to,the,door,and,leave,this,room]) :- room(1), do([exit,room]).
	do([return,to,door,and,leave,this,room]) :- room(1), do([exit,room]).
	do([return,to,the,door,and,leave,the,room]) :- room(1), do([exit,room]).
	do([return,to,door,and,leave,the,room]) :- room(1), do([exit,room]).
	do([return,to,the,door,and,leave,room]) :- room(1), do([exit,room]).
	do([return,to,door,and,leave,room]) :- room(1), do([exit,room]).

do([enter,second,room]) :-
	location(building),
		(key1(true),
			w([
				'Entering the second room - the library - you remember',
				'finding the first room\'s key in here.'
			]),
			location_change(room,2);
		w([
			'You enter the second room.',
			'',
			'You instantly recognize its function: This room must have',
			'been used as a library in the past, because four large,',
			'wooden book shelves that are four meters long, respectively,',
			'reside in this room, and there is a small wooden desk and a',
			'matching chair in a corner. Unlike most people, you\'ve',
			'always liked books - both their haptic qualities and reading',
			'them - so, naturally, you are intrigued.',
			'',
			'You start wandering along the shelves, occasionally picking',
			'out a book and reading a few lines, your flashlight\'s light',
			'being faintly reflected from the pages. Similar to the doors',
			'in the corridor, the books are of varying age and design;',
			'some of them are science books, others are essay',
			'collections, a few are history books, and so on, but the',
			'vast majority is fiction. There\'s a lot of science fiction',
			'and fantasy literature and surprisingly little historic',
			'fiction. What\'s more, three of the books that you\'ve taken a',
			'closer look at have not yet been published - their copyright',
			'years are in the future.',
			'',
			'You take a history book whose dust jacket claims that it',
			'will be released a decade from now, sit down on the chair,',
			'put the book on the desk, and open it. Instead of gaining',
			'knowledge of the future, you find out that the book contains',
			'an antiquated key that looks like it could fit into the lock',
			'on the first door that you saw upon entering the building -',
			'or into the fourteenth room\'s door lock. These two doors',
			'looked almost identical to you back when you entered the',
			'building.'
		]),
		location_change(room,2),
		retract(key1(_)),
		assert(key1(true)));
	roomtests(2).

do([enter,sixth,room]) :-
	location(building),
		w('You enter the sixth room, which appears to be empty.'),
		location_change(room,6);
	roomtests(6).

do([enter,seventh,room]) :-
	location(building),
		w([
			'You enter the seventh room.',
			'',
			'It seems to be empty - if you decide to ignore the giant',
			'sphere, that is. A sphere that couldn\'t be larger, given',
			'the size of the cubic room, reaches from wall to wall and',
			'from floor to ceiling. You can\'t tell what it\'s made of -',
			'its surface looks smooth and black, but darker than any',
			'black object you have seen before: only a unusually small',
			'fraction of your flashlight\'s light is being reflected by',
			'the sphere. But without touching it, you can\'t properly',
			'identify what exactly the sphere made of.'
		]),
		location_change(room,7);
	roomtests(7).

	do([touch,the,sphere]) :- do([touch,sphere]).
	do([touch,sphere]) :-
		location(room),
		room(7),
			w([
				'You extend your left arm, slowly drawing your hand closer to',
				'the sphere until the tip of your middle finger makes',
				'contact. The sphere feels lukewarm, and it seems to vibrate',
				'almost imperceptibly - but other than that, nothing happens.'
			]). 

do([enter,eighth,room]) :-
	location(building),
		w([
			'A layer of thick boards, attached to both sides of the door',
			'frame, prevents you from entering this room. That\'s',
			'surprising - you had seen from the outside that this room\'s',
			'window isn\'t nailed shut anymore. There\'s no way for you to',
			'get past the barrier in front of the door without special',
			'tools, though.',
			'',
			'You consider taking a peek at the room\'s interior when you',
			'leave, but during your exploration of the rest of the',
			'building, you forget about it.'
		]);
	roomtests(8).

do([enter,ninth,room]) :- %-- doing
	location(building),
		(key2(true),
			w([
				'You decide to enter the ninth room, which is rendered',
				'impossible by the fact that it\'s almost completely filled',
				'with cardboard boxes. You chuckle as you remember how much',
				'the box that touched your leg the first time you tried to',
				'enter this room scared you.'
			]);
		w([
			'You open the ninth room\'s door, and something comes out -',
			'there isn\'t enough light to see what it is right away, but',
			'you hear strange noises and feel something touch your leg.',
			'You\'re freaked out and you jump back, only to see that your',
			'attacker is in fact nothing else that a cardboard box.',
			'',
			'There are quite a few cardboard boxes of various sizes',
			'scattered on the floor of the corridor now (the ninth room',
			'is still almost completely filled with the rest of the',
			'boxes), and you see something twinkling next to the small',
			'box that hit you. Bending down to find out what it is, you',
			'discover that you just found a small key. You wonder if',
			'it\'ll be of any use to you later on.'
		]),
		retract(key2(_)),
		assert(key2(true)));
	roomtests(9).

do([enter,tenth,room]) :-
	location(building),
		w([
			'You enter the tenth room, which is empty; but you see a door',
			'in the wall on the right-hand side, which is peculiar as',
			'that wall is one of the outwalls of the building, and you\'re',
			'sure that the industrial building only has one entrance.',
			'',
			'You try to open that door, but turning its handle results in',
			'nothing but a vague creaking sound.' % at this point, I could destroy the main entrance or something
		]),
		location_change(room,10);
	roomtests(10).

do([enter,eleventh,room]) :-
	location(building),
		w([
			'You enter the eleventh room.',
			'',
			'It\'s empty, but its window isn\'t nailed shut - it is',
			'shattered, though. There are cobwebs all over the window',
			'sill, which is something that you haven\'t noticed throughout',
			'the rest of the building. Thinking about it, the whole',
			'building strikes you as oddly clean considering that it has',
			'been abandoned for a few decades.'
		]),
		location_change(room,11);
	roomtests(11).

do([enter,thirteenth,room]) :-
	location(building),
	key2(true),
		w([
			'You try to open the door to the thirteenth room, but it',
			'doesn\'t seem to move at all. Luckily, you\'ve found a key',
			'which appears to match this door\'s design next to one of',
			'the boxes that fell out of the ninth room. You put this key',
			'in the door lock, anxiously turn it once, then turn the door',
			'handle, pull - and the door quietly swings open.',
			'',
			'A strange noise is audible now - it sounds like ticking,',
			'but it\'s uninterrupted. Upon entering the room, your',
			'flashlight aimed towards one of the walls, you discover the',
			'source of the continuous ticking noise: clocks. Hundreds of',
			'them!',
			'',
			'Actually, thousands of clocks of all possible sizes and',
			'shapes cover every single spot on the walls. Ranging from',
			'tiny watches to what appears to be a church clock (you have',
			'never seen one up close before, so you aren\'t quite sure),',
			'you see every imaginable kind of clock, which makes you',
			'think of how we perceive time. Back when humans hadn\'t yet',
			'invented devices that could accurately measure time, they',
			'had to rely on the sun\'s position in the sky, which tends',
			'to be of little use when it\'s overcast cloudy. Accurate',
			'timekeeping has been impossible for most of all human',
			'history. But modern life hevily relies on precise timing,',
			'and, say, stock exchange trading just wouldn\'t work the way',
			'it does if it weren\'t for powerful computers and extremely',
			'fast internet access allowing buying and selling huge',
			'amounts of shares within milliseconds. If all clocks on',
			'earth stopped running, planes would literally drop from the',
			'sky, public transport would collapse, and every single',
			'computer would stop working.',
			'',
			'You shrug off that thought. It\'s all but certain that it',
			'will never happen.'
		]),
		location_change(room,13);
	location(building),
		w([
			'You try to open the door to the thirteenth room, but it',
			'doesn\'t seem to move at all. However, a keyhole sits towards',
			'the right-hand side of the door - maybe a matching key is',
			'hidden in one of the other rooms.'
		]);
	roomtests(13).

do([enter,fourteenth,room]) :-
	location(building),
		w([
			'You enter the fourteenth room - that is, you open the door,',
			'point your flashlight towards the general direction of the',
			'room\'s floor, and swiftly jump back.',
			'',
			'There is no floor, which is pretty uncommon for rooms. By',
			'most definitions, a floorless room tends to be fairly bad at',
			'being a room, after all.',
			'You lie down on your stomach and crawl towards the hole',
			'until you can look down. Pointing your flashlight towards',
			'the general direction of "down", you can\'t see a thing',
			'except a poorly lit cross-section of the building\'s',
			'foundation and the soil beneath it on all four sides of the',
			'room. The hole seems to extend endlessly into the darkness.',
			'',
			'A sudden urge to jump down into the bottomless pit overcomes',
			'you.'
		]),
		location_change(room,14);
	roomtests(14).

	do(['don\'t',jump]) :- do([exit,room]).
	do(['don\'t',jump,down]) :- do([exit,room]).
	do(['don\'t',jump,into,hole]) :- do([exit,room]).
	do(['don\'t',jump,down,into,hole]) :- do([exit,room]).
	do(['don\'t',jump,into,bottomless,pit]) :- do([exit,room]).
	do(['don\'t',jump,down,into,bottomless,pit]) :- do([exit,room]).
	do(['don\'t',jump,into,the,bottomless,pit]) :- do([exit,room]).
	do(['don\'t',jump,down,into,the,bottomless,pit]) :- do([exit,room]).
	do([jump,down]) :- do([jump]).
	do([jump,into,hole]) :- do([jump]).
	do([jump,down,into,hole]) :- do([jump]).
	do([jump,into,bottomless,pit]) :- do([jump]).
	do([jump,down,into,bottomless,pit]) :- do([jump]).
	do([jump,into,the,bottomless,pit]) :- do([jump]).
	do([jump,down,into,the,bottomless,pit]) :- do([jump]).
	do([jump]) :-
		location(room),
		room(14),
			w([
				'You stand up and move towards the emptiness, hardly in',
				'control of your mind and body. You aren\'t actively thinking',
				'about what you\'re doing; even though you know on some level',
				'of consciousness that you\'re going to die if you proceed,',
				'you don\'t fully realize that your actions will result in',
				'death. It\'s almost as if the bottomless pit exercises a',
				'force on you that makes you wish to abandon this life, to',
				'exchange it for an unknown, but by all odds very short and',
				'lethal future.',
				'',
				'You jump.',
				'',
				'There\'s wind, and there\'s sound. The sound of you falling',
				'at an increasingly high velocity, bumping into a wall,',
				'striking another wall, impacting another one.',
				'',
				'Falling faster and faster, touching the walls more often',
				'now, the impacts breaking your skin and bones, your body',
				'disintegrating, you finally lose consciousness.'
			]),
			location_change('bottomless pit').

do([enter,fifteenth,room]) :-
	location(building),
		w('You enter the fifteenth room, which seems to be empty.'),
		location_change(room,15);
	roomtests(15).

do([enter,seventeenth,room]) :-
	location(building),
		w([
			'You enter the seventeenth room.',
			'',
			'It\'s almost empty, yet it\'s so different from the other',
			'rooms. In its the middle, slightly shifted towards the',
			'right, resides a wooden chair, and this room\'s window',
			'strangely happens to be both intact and not nailed shut.',
			'',
			'You close the door behind you, switch off your flashlight,',
			'and take in the view of the hayfield outside the building.',
			'"Actually," you think, "sitting down for a few minutes won\'t',
			'do any harm."'
		]),
		location_change(room,17);
	roomtests(17).

	do([sit,down]) :- do([use,chair]).
	do([sit,down,for,a,few,minutes]) :- do([use,chair]).
	do([sit,down,on,chair]) :- do([use,chair]).
	do([sit,on,chair]) :- do([use,chair]).
	do([sit,down,on,wooden,chair]) :- do([use,chair]).
	do([sit,on,wooden,chair]) :- do([use,chair]).
	do([use,chair]) :-
		location(room),
		room(17),
			w([
				'You approach the chair and sit down. It\'s somewhat relaxing',
				'to just sit here in this calm room in the building you had',
				'been curious about for such a long time. You sure hadn\'t',
				'expected to find a room like this in here. Looking out the',
				'window, you find yourself indulging in memories of the',
				'countless times you had been here before.',
				'',
				'When you were a kindergartner, you had once run away from',
				'home because you were convinced that you were grown-up',
				'enough to travel the world, and had stumbled upon this very',
				'building. Your parents clearly hadn\'t been happy about that',
				'one, but that didn\'t matter: you had found your new',
				'favourite place in the world.',
				'',
				'As you grew older, you came here more often, many times with',
				'friends tagging along. You all devised intricate conspiracy',
				'theories as to what the building had been used for before it',
				'had been abandoned, and after a while, some of your friends',
				'started to attempt to catch a glimpse of its interior by',
				'trying to remove some of the boards that concealed the',
				'windows. But somhow, up until now, not a single one of these',
				'attempts had succeded.',
				'',
				'When you were in your teens, your friends and you would',
				'acquire copious amounts of all kinds of booze, carry it all',
				'the way to the building, and party on warm summer nights.',
				'One night, you had your first kiss on the building\'s roof,',
				'after you had somehow managed to climb it.',
				'',
				'"Good times," you think.',
				'',
				'You decide to visit a room or three more. Standing up from',
				'the wooden chair, you take a last look at the hayfield and',
				'prepare to leave the room.'
			]).

do([enter,nineteenth,room]) :-
	location(room),
	room(20),
		(cube(true),
			w([
				'You open the door and enter the nineteenth room, which is',
				'empty as well - except for the door that leads to the',
				'corridor, which is nailed shut from the outside. You',
				'rememeber finding the Rubik\'s Cube in this room.'
			]);
		w([
			'You open the door and enter the nineteenth room, which seems',
			'to be empty as well - except for the door that leads to the',
			'corridor, which is nailed shut from the outside.',
			'',
			'But upon closer inspection, you spot a small object in a',
			'corner of the room. Walking towards it, you see that it\'s a',
			'normal Rubik\'s Cube. You laugh out loud - who would have',
			'thought that of all the things you could have possibly found',
			'in this building, you\'d find a Rubik\'s Cube!',
			'',
			'You consider solving it.'
		]),
		retract(cube(_)),
		assert(cube(true))),
		location_change(room,19),
		!;
	roomtests(19).

	do([go,back,to,other,room]) :- do([go,back]).
	do([go,back,into,other,room]) :- do([go,back]).
	do([go,back,to,the,other,room]) :- do([go,back]).
	do([go,back,into,the,other,room]) :- do([go,back]).
	do([go,back,to,the,twentieth,room]) :- do([go,back]).
	do([go,back,into,the,twentieth,room]) :- do([go,back]).
	do([go,back,to,twentieth,room]) :- do([go,back]).
	do([go,back,into,twentieth,room]) :- do([go,back]).
	do([go,back,to,room,'20']) :- do([go,back]).
	do([go,back,into,room,'20']) :- do([go,back]).
	do([go,back,to,room,twenty]) :- do([go,back]).
	do([go,back,into,room,twenty]) :- do([go,back]).
	do([go,back]) :-
		location(room),
		room(19),
			do([enter,twentieth,room]).
	do([enter,other,room]) :-
		location(room),
		room(19),
			do([enter,twentieth,room]).

do([enter,twentieth,room]) :-
	location(building),
		w([
			'You enter the twentieth room. It\'s empty, but there\'s a door',
			'in the left-hand side wall of the room, which should in',
			'theory lead to the nineteenth room.'
		]),
		location_change(room,20);
	location(room),
	room(19),
		w('You return to the twentieth room.'),
		location_change(room,20),
		!;
	roomtests(20).

	do([open,door]) :- do([enter,other,room]).
	do([use,door]) :- do([enter,other,room]).
	do([open,the,door]) :- do([enter,other,room]).
	do([use,the,door]) :- do([enter,other,room]).
	do([enter,the,other,room]) :- do([enter,other,room]).
	do([enter,the,next,room]) :- do([enter,other,room]).
	do([enter,next,room]) :- do([enter,other,room]).
	do([enter,other,room]) :-
		location(room),
		room(20),
			do([enter,nineteenth,room]).

do([enter,X,room]) :- % nailed shut rooms
	(X = third; X = fourth; X = fifth; X = twelfth; X = sixteenth; X = eighteenth; X = nineteenth),
		(location(building),
			w([
				'A layer of thick boards, attached to both sides of the door',
				'frame, prevents you from entering this room. There\'s no way',
				'for you to get past this barrier without special tools.'
			]);
		roomtests(0)).

do([enter,_,room]) :-
	location(building),
		w('You can\'t enter a room that doesn\'t exist.');
		%write('You can\'t enter the '),
		%write(X),
		%w([
		%	' room as there are only twenty',
		%	'rooms in the building.'
		%]);
	roomtests(0).

do([exit,room,X]) :-
	room(Y),
	(Y = 1, (X = one; X = '1');
	Y = 2, (X = two; X = '2');
	Y = 3, (X = three; X = '3');
	Y = 4, (X = four; X = '4');
	Y = 5, (X = five; X = '5');
	Y = 6, (X = six; X = '6');
	Y = 7, (X = seven; X = '7');
	Y = 8, (X = eight; X = '8');
	Y = 9, (X = nine; X = '9');
	Y = 10, (X = ten; X = '10');
	Y = 11, (X = eleven; X = '11');
	Y = 12, (X = twelve; X = '12');
	Y = 13, (X = thirteen; X = '13');
	Y = 14, (X = fourteen; X = '14');
	Y = 15, (X = fifteen; X = '15');
	Y = 16, (X = sixteen; X = '16');
	Y = 17, (X = seventeen; X = '17');
	Y = 18, (X = eighteen; X = '18');
	Y = 19, (X = nineteen; X = '19');
	Y = 20, (X = twenty; X = '20')),
		do([exit,room]);
	not(X = one; X = '1'; X = two; X = '2'; X = three; X = '3';
		X = four; X = '4'; X = five; X = '5'; X = six; X = '6';
		X = seven; X = '7'; X = eight; X = '8'; X = nine; X = '9';
		X = ten; X = '10'; X = eleven; X = '11'; X = twelve; X = '12';
		X = thirteen; X = '13'; X = fourteen; X = '14'; X = fifteen; X = '15';
		X = sixteen; X = '16'; X = seventeen; X = '17'; X = eighteen; X = '18';
		X = nineteen; X = '19'; X = twenty; X = '20'),
		w('You can\'t leave a room that doesn\'t exist.');
	w('You can\'t leave a room if you aren\'t inside it.').
do([exit,X,room]) :-
	room(Y),
	(Y = 1, X = first;
	Y = 2, X = second;
	Y = 3, X = third;
	Y = 4, X = fourth;
	Y = 5, X = fifth;
	Y = 6, X = sixth;
	Y = 7, X = seventh;
	Y = 8, X = eighth;
	Y = 9, X = ninth;
	Y = 10, X = tenth;
	Y = 11, X = eleventh;
	Y = 12, X = twelfth;
	Y = 13, X = thirteenth;
	Y = 14, X = fourteenth;
	Y = 15, X = fifteenth;
	Y = 16, X = sixteenth;
	Y = 17, X = seventeenth;
	Y = 18, X = eighteenth;
	Y = 19, X = nineteenth;
	Y = 20, X = twentieth),
		do([exit,room]);
	not(X = first; X = second; X = third; X = fourth; X = fifth;
		X = sixth; X = seventh; X = eighth; X = ninth; X = tenth;
		X = eleventh; X = twelfth; X = thirteenth; X = fourteenth; X = fifteenth;
		X = sixteenth; X = seventeenth; X = eighteenth; X = nineteenth; X = twentieth),
		w('You can\'t leave a room that doesn\'t exist.');
	w('You can\'t leave a room if you aren\'t inside it.').
do([exit,room]) :-
	location(room),
		(room(1),
			w([
				'You decide to go all the way back and leave the room. It',
				'takes quite a while, but you finally catch sight of the',
				'door.',
				'',
				'You leave room 1 and return to the corridor.'
			]),
			location_change(building);
		room(14),
			w([
				'You pull yourself together - there\'s obviously no way you\'d',
				'ever jump into a bottomless pit. You stand up.'
			]),
			location_change(building);
		room(19),
			w('You leave room 19 and return to room 20.'),
			location_change(room,20);
		room(X),
			write('You leave room '),
			write(X),
			w(' and return to the corridor.'),
			location_change(building));
	w('You can\'t leave a room if you aren\'t inside it.').

do([go,home]) :-
	location(outside),
		w('You decide to head home. It\'s been a long day, after all.'),
		location_change(home);
	w('You need to leave the building in order to go home.').

do(_) :-
	w('You can\'t do that right now.').
	%w('That\'s just impossible.').