{ 
File: GuessingGame.pas
Copyright (C) Nelson Ka Hei Chan 2008 <me@nelsonchan.info>
Distributed under the GPLv3 License, See http://www.gnu.org/licenses/gpl-3.0.txt

The program is designed and written by    Nelson Chan
                -    Program  Manual     -
Design:
 Flow and algorithms:
   Greeting -> Enter Menu -> Mode A, B or C ->   Game running  ->  AFR  -> end
                            |__________inside a while loop_____________|
                    |_____________inside a repeat until loop____________|
    Explaination:
     The beginning is simple so i'm going to skip it.
     Let's talk about the while loop first,  it is used to repeat the game part
     but not the whole mode(with the name entering ans instruction), I use
     "request = 'play' " as the parameter to do the loop so in AFR when player
     input 'again' then will assign 'play' to request, and anything else will exit
     the loop e.g. : 'end' , 'menu'(note that 'menu' is not an absolute parameter
     it is just used to repeat the Repeat until loop as i use "until request = 'end'"
     as the parameter to exit the loop, and it would go back to the menu part
     so i just call it 'menu'.
     Talking about the Repeat-Until loop, yes, it is used when user want to go
     to menu in the AFR and quit when request='end'.

 Validation:
   An validation design is used wherever it asks the user to input something.
   It is used to make sure user input the required elements. Also to avoid
   error that will occur when user inputs a non-integer (string) in the MATH part.
   I use the function and variables "val(input,inputvalue,inputcode)".

 Mode A:
    It is a story-based-liked design and a classic one, a random number wil be
    generated and the player need to guess the number, wrong guess -> -HP,
    correct -> +HP and go to next level. With status display. I add a feature
    "magic power"  it can heal the player for 50HP when used.
    The maximum level is 11, that means the player will play 10 levels(begin with lvl 1).
    The game will end when hp <= 0 , level = 11 ,user's termination.
   Flow :
    User input name -> Read instruction? ->
    Choose difficulty -> Start up -> update status display -> user input -> checking -> Game over with messages-> AFR
                                    |_______________A repeat until loop______________|
    |_____________________________________________the while loop______________________________________________________|

 Mode B:
    PVP mode, players choose the ceiling of the range and compete with each other
    who find out the random number first who wins.
    P1 will go first and then P2. The algorithm to determine whose turn is in this way:
    When  var : whoseturn = 1 then P1's turn, whoseturn = 2 then P2's turn.
    While checking, if P1 get it wrong(too small or too large) then set  whoseturn to 2,
    and when P2 get it wrong, set whoseturn to 1.
   Flow:
      User input names -> Read instruction? -> User set the range -> P1,P2-> AFR
                                                                    |_____|  <----A Repeat-Until loop//
                                              |__________the while loop_________|
 Mode C:
    Quite similar to PVP mode but this time VS with computer.
    As usual, player set the range and begin the game.
    Basically just like Mode B, but this time need to do another random function
    to generate computer's guess. I do it by 'computerguess := random(maximum-minimum-1)+(minimum+1)'
    since the maximum and minimum is always changing, so as to keep the random number inside the range.
   Flow: SKIP , similar to Mode B

Remarks:
  All random number generated will  exclude the minimum and maximum.
  The reason is that let's say minimum = 5 and maximum = 10,
  If the magicnum = 5 or 10, it will state the range is 5-6 or 9-10. And if user got the
  number, the program will return the both messages(wrong guess and correct)
  This is a problem, so I just say the Range is Between min and max , where min and max not included.
  and generate the magicnum by 'random(maximum-2)+(minimum+1)',
  therefore the range will be  2 to 9 when max=10 and min=1.
  and 'computerguess := random(maximum-minimum-1)+(minimum+1)'

  I also use the DELAY function to simulate delay to slow down the printing a bit
  to make the user more comfortable when receiving long messages.

!! The magicnum will be shown when using "PROGRAM TEST" as the name          }

program GuessingGame_byNelson;
uses
    crt ;
const
    numberofmodes =3 ;
type
    playedTF= array[1..numberofmodes] of boolean ;
var
    {engine}
     name, name2, request , input ,instruction                    : string     ;
     errordetect,inputvalue , inputcode ,count                    : integer    ;
     FirstTimeToPlay                                              : playedTF   ;
     Key                                                          : LongINT    ;
    {MODE A}
     magicnum, hp, level, NoOfTry, TotalTry ,magicpower,MPlevel   : integer    ;
     minimum, maximum , difficulty                                : integer    ;
    {MODE B & C}
      {minimum, maximum and magicnum also used}
     whoseturn                                                    : integer    ;
     computerguess                                                : integer    ;

{Procedure: Print instruction word by word with delay}
procedure write_instruction(count:integer;time:integer);
begin
 count:=0;
 Repeat
 If KeyPressed then
     Key := Ord(ReadKey);
 If (Key = Ord('s')) or (Key = Ord('S')) Then
  repeat
    count := count + 1 ;
    if NOT((instruction[count] = '/')or(instruction[count]='\')) Then
     write(instruction[count])
    else
     writeln;
  until instruction[count] = '\'
 Else
  begin
  count:=count+1;
  if NOT((instruction[count] = '/')or(instruction[count]='\')) Then
   write(instruction[count])
  else
   writeln;
  delay(time)
  end
 Until instruction[count] = '\'
end;
{End}

{Procedure : Ask for request , what to do?}
procedure AFR_WTD  ;
begin
     If input='end' Then
       begin
         writeln;
         writeln;
         Repeat
          if errordetect = 1 Then
           writeln('Unknown request!');
          write('Do you want to go back to menu? (yes/no)');readln(request);
          If (request = 'yes') or (request = 'no') Then
           errordetect := 0
          Else
           errordetect := 1
         Until errordetect = 0  ;
         If request = 'yes' Then
         begin
          request := 'menu' ;
          clrscr
         end
         Else
          request := 'end'
       end
       Else
        begin
       delay(200);
       writeln;
       writeln;
       writeln;
       writeln;
       writeln;
       writeln('------------------------------------------------------------');
       writeln('What would you like to do now?');
       writeln('Enter:  ''again'' to play again');
       writeln('        ''menu'' to go to menu');
       writeln('        ''end'' to Exit');
       Repeat
        If errordetect = 1 Then
         writeln('ERROR! Unknown request. Try again');
        If errordetect = 2 Then
         writeln('You didn''t enter anything.');
        write('Request: ');readln(request);

        If request = 'again' Then
        begin
         request := 'play';
         errordetect:=0
        end;

        If request = 'end' Then
        begin
         request := 'end' ;
         errordetect := 0
        end ;

        If request= 'menu' Then
        begin
          request := 'menu' ;
          errordetect := 0
        end ;

        If  NOT(request='play') and NOT(request='end') and NOT(request='menu')  Then
         errordetect := 1 ;
        If length(request) = 0 Then
         errordetect := 2    ;
        writeln
       Until (errordetect = 0)
      end
end;
{End Ask for request, what to do?}

{Procedure : Ask for request, read instruction?}
{- ORIGINAL DESIGN -
If FirstTimeToPlay[mode] = true Then
begin
     Repeat
     If errordetect = 1 Then
      writeln('ERROR! Unknown request. Please enter ''yes'' or ''no'' only. Try again');
     If errordetect = 2 Then
      writeln('You didn''t enter anything, please try again');
     write('Would you like to read INSTRUCTION before playing? (yes/no)');readln(request);
     If (request <> 'yes') and (request <> 'no') Then
      errordetect := 1  ;
     If length(request) = 0 Then
      errordetect := 2  ;
     If (request = 'yes') or (request = 'no') Then
      errordetect := 0  ;
     writeln
    Until  errordetect = 0;
    FirstTimeToPlay[mode]:=False ;
    If request = 'yes' Then
     request := 'instruction'
    Else
     request := 'play'
end
Else
     request := 'play' ;
    clrscr   }
procedure AFR_RI(mode : integer);
begin
   If FirstTimeToPlay[mode] = true Then
   begin
      request := 'instruction'  ;
      FirstTimeToPlay[mode] := false
   end
   Else
      request := 'play';
clrscr
end;
{End procedure AFR_RI}

{MAIN PROGRAM BODY}
begin
{initialization}
count:=0;
clrscr;
For count := 1 to 3 do
  FirstTimeToPlay[count] := true;
errordetect  := 0 ;
randomize;
{End initialization}
    textcolor(white);
    writeln('+++Guessing Game+++');
    writeln('-by Nelson , Last updated: 13:22 @29.03.2008  ')   ;
    instruction:='//Welcome to play this game!/It''s all about Guessing!!/\                                        ';
    write_instruction(count,10);    Key := 0 ;
    writeln ;
    delay(200);
    write('Press ENTER when ready');readln;
Repeat
    clrscr;
      {Ask for request, main menu}
    writeln('- Menu -');
    writeln('Choose a mode to play : ');
    writeln('A: Single Player');
    writeln('B: Player V.S. Player');
    writeln('C: Player V.S. Computer');
    writeln;
    writeln('Q:  Quit');
    writeln ;
    Repeat
      If errordetect = 1 Then
       writeln('ERROR! Input the alphabet only.');
      If errordetect = 2 Then
       writeln('You didn''t input anything. ');
      write('Input the corresponding alphabet: ');readln(request);
      If   (request = 'A')or(request='a')
         or(request = 'B')or(request='b')
         or(request = 'C')or(request='c')
         or(request = 'Q')or(request='q') Then
      begin
          If (request = 'Q')or(request='q') Then
           request:= 'end';
       errordetect := 0
      end
      Else
       errordetect := 1;
      If length(request) = 0 Then
       errordetect := 2;
      writeln
    Until errordetect = 0 ;
     {End AFR main menu}


 If (request = 'A') or (request = 'a') Then          {MODE A}
 begin
    clrscr;
    {Input name, name contain <=38 characters}
    Repeat
     If errordetect = 1 Then
      writeln('ERROR! Name too long. Enter a name which contains <= 38 characters.');
     If errordetect = 2 Then
      writeln('ERROR! you didn''t input anything, try again.');
     write('Enter your name: ');readln(name);
     If (length(name) <= 38) and (length(name)<>0) Then
      errordetect := 0;
     If length(name) > 38 Then
      errordetect := 1;
     If length(name) = 0 Then
      errordetect := 2;
     writeln
    Until errordetect = 0 ;
    {End input name}
     AFR_RI(1);    {Call procedure ask for request, read instruction?}
    {Instruction}
    If request = 'instruction' Then
    begin
     writeln('INSTRUCTIONS           (Press [s] to skip)') ;
     writeln;
     instruction:='Listen up,/At the beginning you will have 100hp./A Magic number will be generated in each level\';
     write_instruction(count,50);
     instruction:='You need to guess what the magic number is.\';
     write_instruction(count,50);
     instruction:='The range of the number will be shown in the status display.\';
     write_instruction(count,50);
     instruction:='5HP damage will be taken for each incorrect guess,\';
     write_instruction(count,50);
     instruction:='and heal for 20HP for every correct guess and proceed to the next level.\';
     write_instruction(count,50);
     instruction:='There are 10 levels totally./Besides, there is something called "Magic Power"\';
     write_instruction(count,50);
     instruction:='it can recover your HP for 50HP/To use it, type "magic" when it ask you to guess.\';
     write_instruction(count,50);
     instruction:='You will receive 1 Magic Power for completing every 5 levels\';
     write_instruction(count,50);
     writeln('------------------------------');
     write('Ready? Press ENTER to continue ...');
     readln;
     request := 'play' ;
    end;  Key := 0;
    {End instruction}
    {outter loop PLAY}
      While request = 'play' Do
      begin
      clrscr;
    {Ask for request , difficulty?}
    writeln('Choose a difficulty  ');
    writeln('1 : Normal');
    writeln('2 : Hard');
    Repeat
     If errordetect = 1 Then
      writeln('ERROR! Unknown request. Enter 1 or 2 only, try again');
     If errordetect = 2 Then
      writeln('You didn''t enter anything.');
     write('Input the corresponding number : ');readln(request);
     If (request <> '1') and (request <> '2') Then
      errordetect := 1 ;
     If length(request) = 0 Then
      errordetect := 2 ;
     If (request = '1') or (request = '2') Then
      errordetect := 0
    Until errordetect = 0;

    If request = '1' Then    {processing}
     difficulty := 50;
    If request = '2' Then
     difficulty := 100;
    clrscr;
    {End ask for request}

       {Initialization & reset}
       magicnum    := random(1)       ;
       inputvalue  := 0               ;
       inputcode   := 0               ;
       hp          := 100             ;
       level       := 1               ;
       magicpower  := 0               ;
       minimum     := 1               ;
       maximum     := Level*difficulty;
       NoOfTry     := 0               ;
       TotalTry    := 0               ;
       MPlevel     := 0               ;
       {End initialization & reset}

    {Core Running}
  Repeat
   {startup and changes after passing a level}
   magicnum := random(level*difficulty-2)+2;
   NoOfTry := 0;
   maximum := level * difficulty ;
   minimum := 1;
   If MPlevel = 5 Then
    begin
     magicpower:=magicpower+1;
     MPlevel := 0
    end;
   {end startup and changes}

   Repeat
     {Status display}
      writeln('++++++++++++++++++STATUS DISPLAY++++++++++++++++++') ;
      writeln('+ Player: ',                           name:38,' +') ;
      writeln('+ HP    : ',                             hp:38,' +') ;
      writeln('+ Magic Power left:',            magicpower:29,' +') ;
      writeln('+ Level : ',                          level:38,' +') ;
      writeln('+ Range : ', ' ':15, 'Between ',minimum:5,' and ',  maximum:5,' +') ;
      writeln('+ No.of try: ',                     NoOfTry:35,' +') ;
     If TotalTry = 0 Then
      writeln('+ Accuracy :                            stand by +')
     Else
       writeln('+ Accuracy : ',   (level-1)/TotalTry*100:34:2,'% +');
      writeln('++++++++++++++++++++++++++++++++++++++++++++++++++') ;
      writeln('*You may quit the game by inputting ''end''*');
      writeln('*Input ''magic'' to use Magic power*');
      {End status display}

       writeln;
       If name = 'PROGRAM TEST'  Then
        writeln('#The magic number is ',magicnum,' #');
        {Input}
         Repeat
          writeln;
          If errordetect = 1 Then
           writeln('ERROR! Input an integer only, try again');
          If errordetect = 2 Then
           writeln('You didn''t input anything, try that again.');
          write('Make a guess : ');readln(input);
          val(input,inputvalue,inputcode) ;
          If inputcode <> 0 Then
           errordetect := 1   ;
          If length(input) = 0 Then
           errordetect := 2   ;
          If ((inputcode = 0) and (length(input) <> 0)) or (input = 'end') or (input = 'magic') Then
           errordetect := 0
         Until (errordetect = 0) ;
        {End input}

{Ignore checking while input 'end' or 'magic'}
         If  NOT(input = 'end') AND NOT(input = 'magic')  Then
      begin
        delay(200);
       {Checking}
        If (inputvalue <= minimum) or (inputvalue >= maximum) Then
         begin
          writeln('The number is out of range!');
          write('Press ENTER to continue... ');readln
         end ;

        If (inputvalue > magicnum) and (inputvalue < maximum) Then
         begin
         NoOfTry := NoOfTry+1 ;   TotalTry := TotalTry+1 ;
         maximum := inputvalue ;
         hp := hp - 5;
         If hp = 0 Then
          writeln('Muahaha..You''ve died! The magic number is ',magicnum,'. Try harder next time!')
         Else
          begin
           writeln('The number is too large!');
           writeln('5HP Damage received! Your HP becomes ',hp);
           If hp = 5 Then
            writeln('You are dying, here comes your last chance')
          end;
         write('Press ENTER to continue... ');readln
         end  ;

        If (inputvalue < magicnum) and (inputvalue > minimum) Then
         begin
          NoOfTry := NoOfTry+1 ;   TotalTry := TotalTry+1 ;
          minimum := inputvalue ;
          hp := hp - 5;
         If hp = 0 Then
          writeln('Muahaha..You''ve died! The magic number is ',magicnum,'. Try harder next time!')
         Else
          begin
           writeln('The number is too small!');
           writeln('5HP Damage received! Your HP becomes ',hp);
           If hp = 5 Then
            writeln('You are dying, here comes your last chance')
          end;
          write('Press ENTER to continue... ');readln
         end ;

        If inputvalue = magicnum Then
         begin
          level := level + 1 ;
          hp := hp+20;
          MPlevel := MPlevel+1;
          TotalTry := TotalTry +1 ;
          writeln('Congradulations! You are correct!');
          If level = 11 Then
          begin
           writeln('You have completed the game!!!');
           write('Press ENTER to continue..');readln
          end
          Else
          begin
           if NoOfTry = 0 Then
            writeln('Lucky huh? Just see if you have the luck with you all the time.')
           else
            writeln('You have tried for ',NoOfTry,' times before you''ve got the number.');
           write('Press ENTER to proceed to level ', level);readln
          end
         end
     end
     Else
      begin
       If input = 'magic' Then{MAGIC}
       begin
         If magicpower <= 0 Then
          begin
           writeln('You don''t have any Magic Power.');
           write('Press ENTER to continue... ');readln
          end
         Else
          begin
           writeln('~~~~~~~MAGIC~~~~~~~');
           hp:=hp+50 ;
           magicpower := magicpower - 1;
           writeln('You are heal for 50HP, your HP becomes ', hp);
           write('Press ENTER to continue...');readln
          end   {End MAGIC}
         end

        end  ;
       {End Checking}
        clrscr
    Until  (hp<=0) or (inputvalue = magicnum) or (input = 'end') or (level = 11)    {loop within the same level}

   Until (hp<=0) or (input='end') or (level = 11);    {GAME OVER}
       writeln('GAME OVER!!');
       if input= 'end' Then
        writeln('Reason: User sends end');
       If level = 11 Then
        writeln('Reason: You have completed the game!!');
       if hp <= 0 then
        writeln('Reason: You died at Level ', level);
       if input <> 'end' Then
       begin
        write('Your accuracy is : '); writeln((level-1)/TotalTry*100:0:2,'%');
       write('Rank: ');  delay(500);
        If level = 1 Then
         writeln('You didn''t play it seriously.')
        Else
         begin
          Case round((level-1)/TotalTry*100) Of
            0..  5: writeln('Poor!');
            6.. 10: writeln('Good Try');
           11.. 15: writeln('Not bad!');
           16.. 20: writeln('Nice job!');
           21.. 25: writeln('Expert!');
           26.. 30: writeln('Excellent!!')
           Else     writeln('GOD LIKE!!!')
          End
         end
        end;
       write('Press ENTER to continue... '); readln;
   {End game over messages}
       AFR_WTD{Call  Ask for request_what to do}
  end      {loop PLAY}
 end;       {End MODE A}

 {MODE B}
If (request = 'B')or(request='b') Then
begin
    clrscr;
    {Input Player 1 name}
    Repeat
     If errordetect = 2 Then
      writeln('ERROR! you didn''t input anything, try again.');
     write('Enter the name of Player 1 : ');readln(name);
     If length(name) > 0 Then
      errordetect := 0
     Else
      errordetect := 2;
    Until errordetect = 0 ;
    {End input name}
    {Input Player 2 name}
    Repeat
     If errordetect = 2 Then
      writeln('ERROR! you didn''t input anything, try again.');
     write('Enter the name of Player 2 : ');readln(name2);
     If length(name2) > 0 Then
      errordetect := 0
     Else
      errordetect := 2;
     writeln
    Until errordetect = 0 ;
    {End input name}
     AFR_RI(2);    {Call procedure ask for request, read instruction?}
    {Instruction}
    If request = 'instruction' Then
    begin
     writeln('INSTRUCTION           (Press [s] to skip)');
     writeln;
     instruction:='Listen up,/First you two have to choose the top range of the random number.\';
     write_instruction(count,50);
     instruction:='Then, a random number will be generated base on the range given by you.\';
     write_instruction(count,50);
     instruction:='In the game, you two will have to compete with each other.\';
     write_instruction(count,50);
     instruction:='The one who get the number first will win.\';
     write_instruction(count,50);
     writeln('---------------------------------------------------');
     write('Ready? Press ENTER to continue..');readln
    end;   Key := 0;
    {End Instruction}
    clrscr;
    request := 'play' ;

    While request = 'play' Do
    begin
     clrscr;
     minimum:=1;
     {Input max range}
      Repeat
       If errordetect = 1 Then
        writeln('ERROR! Input an integer >=3 and <=32767 only!');
       If errordetect = 2 Then
        writeln('You didn''t enter anything, try again.');
       write('Enter the maximum value of the range: ');readln(input);
       val(input, maximum ,inputcode);
       If (inputcode = 0) and (maximum >= 3) and(maximum<=32767) Then
         errordetect:=0
       Else
        errordetect := 1 ;
       If length(input)=0 Then
        errordetect := 2 ;
       writeln
      Until errordetect = 0;
     {End input max range}
       magicnum := random(maximum-2)+(minimum+1);
       whoseturn := 1 ;

{Game running}
         Repeat

{P1}
          If whoseturn = 1 Then
          begin
           clrscr;
           writeln('*You may end the game by inputting ''end''*');
           writeln;
           writeln;
           If name = 'PROGRAM TEST' Then
            writeln('#The magic number is : ',magicnum,' #')  ;
           writeln('The magic number is between ',minimum,' and ',maximum );
{P1 Input}
           Repeat
            writeln;
            If errordetect = 1 Then
             writeln('ERROR! Input an integer only. Try again');
            If errordetect = 2 Then
             writeln('ERROR! You didn''t input anything, try that again.');
            write('(P1) ',name,'''s turn: ');readln(input);
            val(input,inputvalue,inputcode) ;
            If inputcode <> 0 Then
             errordetect := 1   ;
            If length(input) = 0 Then
             errordetect := 2   ;
            If ((inputcode = 0) and (length(input) <> 0)) or (input = 'end')Then
            errordetect := 0
           Until (errordetect = 0) ;
{End P1 input}
     writeln;
{P1 Check}
      If  NOT(input = 'end')  Then           {ignore checking when input ='end'}
      begin delay(200);
        If (inputvalue <= minimum) or (inputvalue >= maximum) Then
         begin
          writeln('The number is out of range, try again.');
          write('Press ENTER to continue... ');readln
         end ;

        If (inputvalue > magicnum) and (inputvalue < maximum) Then
         begin
           maximum := inputvalue ;
           whoseturn:=2 ;
           writeln('The number is too large!');
           writeln('Now is (P2) ',name2,'''s turn!');
           write('Press ENTER to continue... ');readln
         end  ;

        If (inputvalue < magicnum) and (inputvalue > minimum) Then
        begin
           minimum := inputvalue ;
           whoseturn:=2  ;
           writeln('The number is too small!');
           writeln('Now is (P2) ',name2,'''s turn!');
           write('Press ENTER to continue... ');readln
        end ;

        If inputvalue = magicnum Then
        begin
          writeln('(P1)',name,' has got the magic number!');
          writeln('(P1)',name,' WINS the game!!');
          write('Press ENTER to continue..');readln ;
          request := 'finish'
        end
     end
{End P1 Check}
          end ;     {work with the If whoseturn = 1}
{End P1}

{P2}
         If whoseturn = 2 Then
         begin
           clrscr;
           writeln('*You may end the game by inputting ''end''*');
           writeln;
           writeln;
           If name2 = 'PROGRAM TEST' Then
            writeln('#The magic number is : ',magicnum,' #')  ;
           writeln('The magic number is between ',minimum,' and ',maximum );
{P2 input}
           Repeat
            writeln;
            If errordetect = 1 Then
             writeln('ERROR! Input an integer only. Try again');
            If errordetect = 2 Then
             writeln('ERROR! You didn''t input anything, try that again.');
            write('(P2) ',name2,'''s turn: ');readln(input);
            val(input,inputvalue,inputcode) ;
            If inputcode <> 0 Then
             errordetect := 1   ;
            If length(input) = 0 Then
             errordetect := 2   ;
            If ((inputcode = 0) and (length(input) <> 0)) or (input = 'end')Then
            errordetect := 0
           Until (errordetect = 0) ;
{End P2 input}
       writeln;
{P2 Check}
      If  NOT(input = 'end')  Then           {ignore checking when input ='end'}
      begin  delay(200);
        If (inputvalue <= minimum) or (inputvalue >= maximum) Then
         begin
          writeln('The number is out of range, try again.');
          write('Press ENTER to continue... ');readln
         end ;

        If (inputvalue > magicnum) and (inputvalue < maximum) Then
         begin
           maximum := inputvalue ;
           whoseturn:=1 ;
           writeln('The number is too large!');
           writeln('Now is (P1) ',name,'''s turn!');
           write('Press ENTER to continue... ');readln
         end  ;

        If (inputvalue < magicnum) and (inputvalue > minimum) Then
        begin
           minimum := inputvalue ;
           whoseturn:=1 ;
           writeln('The number is too small!');
           writeln('Now is (P1) ',name,'''s turn!');
           write('Press ENTER to continue... ');readln
        end ;

        If inputvalue = magicnum Then
        begin
          writeln('(P2)',name2,' has got the magic number!');
          writeln('(P2)',name2,' WINS the game!!');
          write('Press ENTER to continue..');readln ;
          request := 'finish'
        end
     end
{End P2 Check}
         end ;  {work with If whoseturn = 2}
{End P2}
         Until (request = 'finish') or (input = 'end') ;
{Game stop}

       AFR_WTD{Call  Ask for request_what to do}

    end   {the while 'play' loop}
end; {End MODE B}


{MODE C}
If (request = 'C') or (request = 'c') Then
begin
    clrscr;
{Input name}
    Repeat
     If errordetect = 2 Then
      writeln('ERROR! you didn''t input anything, try again.');
     write('Enter the name of Player : ');readln(name);
     If length(name) > 0 Then
      errordetect := 0
     Else
      errordetect := 2;
     writeln
    Until errordetect = 0 ;
{End input name}
    AFR_RI(3);    {Call procedure ask for request, read instruction?}
{Instruction}
    If request = 'instruction' Then
    begin
     writeln('INSTRUCTION           (Press [s] to skip)');
     writeln;
     instruction:='Listen!/You are going to compete with the Computer.\';
     write_instruction(count,50);
     instruction:='You will be asked to input the maximum range of the magic number.\';
     write_instruction(count,50);
     instruction:='After that, a magic number will be generated randomly base on the range given.\';
     write_instruction(count,50);
     instruction:='The one who find out the magic number will win the game!\';
     write_instruction(count,50);
     writeln('---------------------------------------------------');
     write('Ready? Press ENTER to continue..');readln
    end;    Key := 0;
{End Instruction}
    request := 'play';
   While request = 'play'  Do
   begin
      clrscr;
     {initialisation}
      computerguess:= random(1);
      minimum := 1 ;
     {end initialisation}

{Input max range}
      Repeat
       If errordetect = 1 Then
        writeln('ERROR! Input an integer >=3 and <=32767 only!');
       If errordetect = 2 Then
        writeln('You didn''t enter anything, try again.');
       write('Enter the maximum value of the range: ');readln(input);
       val(input, maximum ,inputcode);
       If (inputcode = 0) and (maximum >=3)and(maximum<=32767) Then
         errordetect:=0
       Else
        errordetect := 1 ;
       If length(input)=0 Then
        errordetect := 2 ;
       writeln
      Until errordetect = 0;
{End input max range}
      magicnum := random(maximum-2)+(minimum+1) ; {Generate magicnum}
      whoseturn := 1 ;
{Game running}
         Repeat
         clrscr;
{Player}
          If whoseturn = 1 Then
          begin
           clrscr;
           writeln('*You may end the game by inputting ''end''*');
           writeln;
           If name = 'PROGRAM TEST' Then
            writeln('#The magic number is : ',magicnum,' #')
           Else
            writeln;
           writeln('The magic number is between ',minimum,' and ',maximum );
{Player Input}
           Repeat
           writeln;
            If errordetect = 1 Then
             writeln('ERROR! Input an integer only. Try again');
            If errordetect = 2 Then
             writeln('ERROR! You didn''t input anything, try that again.');
            write('(Player) ',name,'''s turn: ');readln(input);
            val(input,inputvalue,inputcode) ;
            If inputcode <> 0 Then
             errordetect := 1   ;
            If length(input) = 0 Then
             errordetect := 2   ;
            If ((inputcode = 0) and (length(input) <> 0)) or (input = 'end')Then
            errordetect := 0
           Until (errordetect = 0) ;
{End Player input}
     writeln;
{Player Check}
      If  NOT(input = 'end')  Then           {ignore checking when input ='end'}
      begin  delay(200);
        If (inputvalue <= minimum) or (inputvalue >= maximum) Then
         begin
          writeln('The number is out of range, try again.');
          write('Press ENTER to continue... ');readln
         end ;

        If (inputvalue > magicnum) and (inputvalue < maximum) Then
         begin
           maximum := inputvalue ;
           whoseturn:=2 ;
           writeln('The number is too large!');
           writeln('Now is Computer''s turn!');
           write('Press ENTER to continue... ');readln
         end  ;

        If (inputvalue < magicnum) and (inputvalue > minimum) Then
        begin
           minimum := inputvalue ;
           whoseturn:=2  ;
           writeln('The number is too small!');
           writeln('Now is Computer''s turn!');
           write('Press ENTER to continue... ');readln
        end ;

        If inputvalue = magicnum Then
        begin
          writeln('YOU WIN! ',name,' has got the magic number!');
          writeln('(Player)',name,' WINS the game!!');
          write('Press ENTER to continue..');readln ;
          request := 'finish'
        end
     end
{End Player Check}
          end ;     {work with the If whoseturn = 1}
{End Player}

{CPU}
         If whoseturn = 2 Then
         begin
          clrscr;
          writeln('*You may end the game by inputting ''end''*');
          writeln;
          writeln;
          writeln('The magic number is between ',minimum,' and ',maximum );
          writeln;
{CPU input}
       {AI}
          If  maximum-minimum >=50 then
           computerguess := minimum + (maximum-minimum)DIV 2
          Else
          begin
            If maximum-minimum = 4 Then
             repeat
              computerguess := random(maximum-minimum-1)+(minimum+1)
             until (computerguess <> maximum-2) and (computerguess <> minimum+2)
            Else
             If maximum-minimum = 3 Then
              computerguess := random(maximum-minimum-1)+(minimum+1)
             Else
              repeat
               computerguess := random(maximum-minimum-1)+(minimum+1)
              until (computerguess <> maximum -2) and (computerguess <> minimum +2)
          end  ;
       {End AI}
          write('Computer''s turn: ');
          delay(500);
          writeln(computerguess);
{End CPU input}
       writeln; delay(200);
{CPU Check}
        If (computerguess <= minimum) or (computerguess >= maximum) Then
         begin
          writeln('The number is out of range, try again.');
          write('Press ENTER to continue... ');readln
         end ;

        If (computerguess > magicnum) and (computerguess < maximum) Then
         begin
           maximum := computerguess ;
           whoseturn:=1 ;
           writeln('The number is too large!');
           writeln('Now is (Player) ',name,'''s turn!');
           write('Press ENTER to continue... ');readln
         end  ;

        If (computerguess < magicnum) and (computerguess > minimum) Then
        begin
           minimum := computerguess ;
           whoseturn:=1 ;
           writeln('The number is too small!');
           writeln('Now is (Player) ',name,'''s turn!');
           write('Press ENTER to continue... ');readln
        end ;

        If computerguess = magicnum Then
        begin
          writeln('YOU LOST! Computer has got the magic number!');
          writeln('Computer WINS the game!!');
          write('Press ENTER to continue..');readln ;
          request := 'finish'
        end
{CPU Check}
         end   {work with If whoseturn = 2}
{End CPU}
         Until (request = 'finish') or (input = 'end') ;
{Game stop}
       AFR_WTD{Call procedure: Ask for request,what to do}
   end; {the while play loop}
end
{End MODE C}

Until request = 'end' ;                   {so when request = 'menu' will repeat the loop}
writeln;
write('Press ENTER to quit..');readln
end.
