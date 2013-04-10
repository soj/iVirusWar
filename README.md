iVirusWar game application

![My image](soj.github.com/iVirusWar/imgages/iVirusWar.png)

=========

Rules of the Game (translated by Google Translate from http://ru.wikipedia.org/wiki/%D0%92%D0%BE%D0%B9%D0%BD%D0%B0_%D0%B2%D0%B8%D1%80%D1%83%D1%81%D0%BE%D0%B2

- Play in the "war on viruses" two players on a board of 10 by 10 cells, one crosses the other crosses.
- Take turns. Begin crosses. Each turn consists of three separate consecutive moves (we call them "clocks").
- Each "clocks" is either a reproduction or killing. Reproduction - is exhibiting its character in any available empty cell boards, and a slew of - this ad killed a foreign character that is accessible to the cell.
- Cage is available to cross if it is either in direct contact (horizontal, vertical or diagonal) with a live cross, or through a chain of dead toe (but not through a chain of dead crosses!).
- Similarly defined cells available to toe, either in direct contact with one of the O's, or through a chain of dead crosses.
- Killed crosses encircling the slain toe paint. If the game is not on the paper board, and the board with "reusable" and chips with images of noughts and crosses, the chip should be killed to cover his chip.
- Initially, the game board is empty, and the fields available for the dagger is not, so an exception they have the right to make the first "clocks" on a1. Similarly Crosses are entitled to their first "clocks" exhibit at k10.
- At any point the player can refuse to move. However, running full speed, instead of only one or two "clocks" are prohibited, except in the case where complete a full course impossible in principle.

Prohibited: 

- To put his character in an occupied cell.
- Killing the enemy is dead characters. 

The goal is the complete destruction of the enemy's colony (ie, a slew of the enemy characters). 
If both players are considering such destruction impossible to refuse to move, game is drawn. 
In SESC USU played a variant in which winner is the player who made​the last move, and in this version there is a tie. 

Взято тут - http://ru.wikipedia.org/wiki/%D0%92%D0%BE%D0%B9%D0%BD%D0%B0_%D0%B2%D0%B8%D1%80%D1%83%D1%81%D0%BE%D0%B2

Правила игры

Игровое поле в начале игры

- Играют в «войну вирусов» два игрока на доске 10 на 10 клеток, один крестиками, другой ноликами.
- Ходят поочерёдно. Начинают крестики. Каждый ход состоит из трёх отдельных последовательных ходов (назовём их «ходиками»).
- Каждый «ходик» является либо размножением, либо убиванием. Размножение — это выставление своего символа в любую доступную пустую клетку доски, а убивание — это объявление убитым некоторого чужого символа, который находится на доступной клетке.
- Клетка считается доступной для крестиков, если она либо непосредственно соприкасается (по вертикали, горизонтали или диагонали) с живым крестиком, либо через цепочку убитых ноликов(но не через цепочку убитых крестиков!).
- Аналогично определяются клетки, доступные для ноликов: либо непосредственно соприкасающиеся с одним из ноликов, либо через цепочку убитых крестиков.
- Убитые крестики обводятся кружком, убитые нолики закрашиваются. Если игра ведётся не на бумажной доске, а при помощи доски «многоразового использования» и фишек с изображениями крестиков и ноликов, то убитую фишку надо накрыть своей фишкой.
- Вначале игры доска пуста, и полей доступных для крестиков нет, поэтому в порядке исключения они имеют право сделать свой первый «ходик» на a1. Точно также нолики имеют право своим первым «ходиком» выставиться на k10.
- В любой момент игрок может отказаться от хода. Однако выполнение вместо полного хода лишь одного или двух «ходиков» запрещается, за исключением того случая, когда выполнить полный ход невозможно в принципе.

Запрещается:

- Ставить свой символ в уже занятую клетку.
- Убивать уже убитые символы противника.

Целью игры является полное уничтожение колонии противника (то есть убивание всех вражеских символов). 
Если оба игрока, считая такое уничтожение невозможным, отказываются от хода, партия считается закончившейся вничью. 
В СУНЦ УрГУ игрался вариант, в котором выигравшим считался игрок, сделавший последний ход; в таком варианте ничьей не существует.

-----

The main problem today is very slow moves finding. Trying to improve timing.
 
You can set maximum thinking time for computer in seconds via 
#define maxThinkingTimeSec 100 in Virus.m 
