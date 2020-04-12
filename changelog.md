# alpha-v1.1.0 (unreleased, WIP)

Change Log:
- Reduced delay between exit command and app closing from 5s to 3s
- Added dictionary import feature (imported dictionaries do not persist and must be reimported after the session is closed)
- Separated games into 5 duration categories: Short (2mins), Classic (2mins), Long (5mins), Custom (player inputted duration) and Sandbox (317 years)
- Added separate highscores for each game category except custom, including an "average points per second" category
- Added pauses between most actions, to allow players to see the output better
- Add confirmation before game start to prevent timer from starting before player is ready to begin
- Display maximum attainable score on game end
- End game early if player has played all valid words

# alpha-v1.0.1
Hotfix to correct typo in startup message.

Change Log:
- Correct "DeBongglesEquation" to "DeBonggliesEquation" in startup message

# alpha-v1.0
First release.

Available Features:
- Singleplayer with randomized Boggle Board
- Singleplayer with user inputted Boggle Board
- Per session highscore tracking
