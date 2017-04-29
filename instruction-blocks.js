// declare consent block
var consent_block = {
    type: 'html',
    url: "consent_page.html",
    cont_btn: "start",
    check_fn: check_consent,
    data: {
        block_task: 'consent_block'
    }
}

// define welcome message block (overview of experiment)
var welcome_block = {
    type: 'instructions',
    pages: [
        '<strong>Welcome to the experiment</strong> ' +
        '<br />In the <strong>first</strong> part of the experiment, you are asked to create a sequence of Rock, Paper, Scissors that is as random as possible.' +
        '<ul><li>   For Rock: press the letter "g" on the keyboard.' +
        '<li>       For Paper: press the letter "h" on the keyboard. ' +
        '<li>       For Scissors: press the letter "b" on the keyboard. </ul>' +
        'Please take a moment to locate these keys on your keyboard now and to remember the mapping of letters to rock, paper, and scissors. ' +
        '<p>At the beginning of each trial, you will see a 3-2-1 countdown on the screen, followed by a red "GO!" signal. ' +
        'You must press "g", "h", or "b" as soon as you see the go signal. You will only have half a second to enter your response. ' +
        'Most importantly, <em>please make a conscious effort to create a series of Rock, Paper and Scissors that is as random as possible. </em>' +
        'It might help you to visualize this task as casting a 3-faced die. You can also try to imagine a computer program that spits out "Rock!", "Paper!" or "Scissors!" at random, in an unpredictable fashion.' +
        'The 10 first trials will serve as practice, for you to get accustomed to the experimental environment. Then you will begin your random sequence generation. </p>' +
        '<p>In the <strong>second</strong> part of the experiment, you will play rounds of Rock-Paper-Scissors against the computer. Your goal is to win as many rounds as possible. Once again, you will have the three natural options "Rock", "Paper" and "Scissors" to choose from, which you will select by pressing the same keys as in part 1. </p>' +
        'Reminder: Rock beats Scissors, Scissors beat Paper, and Paper beats Rock. ' +
        'The winner of the game will be determined by the amount of points you end up with. Both yourself and the computer will be allotted 100 points before starting the game. You will both obtain or lose points in the following manner:' +
        '<ul><li>You win: you receive 1 point, and the computer loses 1 point.' +
        '<li>You tie: both scores remain the same' +
        '<li>You lose: you lose 1 point, and the computer receives 1 point. </ul>' +
        'This means that if you lose a round (example: you play Paper and the computer plays Scissors), not only will you lose a point but the computer will gain one. ' +
        'Again, you will see the 3-2-1 countdown and the red "GO!" appear on the screen. If you do not press one of the keys (G, H or B) within a half second of the red "GO!" appearing, you will lose one point but the computer will not gain a point. ' +
        '<p>The <strong>third</strong> part of the experiment will be exactly the same as the first part: you will again generate a sequence of Rock, Paper and Scissors that is as random and unpredictable as possible. To help you picture this once more, you can imagine that your iPod only contains three songs titled "Rock", "Paper" and "Scissors", and you hit the Shuffle button repeatedly so that the iPod chooses one of the songs at random each time. It is crucial in these two parts that you literally try to act like your iPod, or the die, or the computer algorithm and make your sequence completely random. </p>'
    ],
    show_clickable_nav: true,
    data: {
        block_task: 'welcome_block'
    }
}

// define instructions block for Part 1
var instructions_block1 = {
    type: 'instructions',
    pages: [
        'Welcome to Part <strong>ONE</strong> of the game. ' +
        '<br />Please generate a random sequence of 3 events "Rock", "Paper" and "Scissors". ' +
        '<br />You are asked to press the 3 buttons (G,H, or B) as randomly as possible. ' +
        '<br />(Note that: the "g" key represents "Rock", the "h" key represents "Paper", and the "b" key represents "Scissors". ' +
        '<br />We will begin with a practise round. Press "next" when you are ready. ',

        '<strong> PRACTICE BLOCK </strong>'
    ],
    show_clickable_nav: true,
    data: {
        block_task: 'instructions_block_one'
    }
}

// define instructions block for Part 2a (aware_predict)
var instructions_block2a = {
    type: 'instructions',
    pages: [
        'This is now part <strong>TWO</strong> of the experiment',
        'You will be predicted...this is condition 2a',
        'GL and begin'
    ],
    show_clickable_nav: true,
    data: {
        block_task: 'instructions_block_two_a'
    }
}

// define instructions block for Part 2b (unaware_predict)
var instructions_block2b = {
    type: 'instructions',
    pages: [
        'This is now part <strong>TWO</strong> of the experiment',
        'You will be predicted (but not told)...this is condition 2b',
        'GL and begin'
    ],
    show_clickable_nav: true,
    data: {
        block_task: 'instructions_block_two_b'
    }
}

// define instructions block for Part 2c (unaware_no_predict)
var instructions_block2c = {
    type: 'instructions',
    pages: [
        'This is now part <strong>TWO</strong> of the experiment',
        'You will NOT be predicted...this is condition 2c',
        'GL and begin'
    ],
    show_clickable_nav: true,
    data: {
        block_task: 'instructions_block_two_c'
    }
}

// define instructions block for Part 3
var instructions_block3 = {
    type: 'instructions',
    pages: [
        'Welcome to Part <strong>THREE</strong> of the game. ' +
        '<br />Please generate a random sequence of 3 events "Rock", "Paper" and "Scissors". ' +
        '<br />You are asked to press the 3 buttons (G,H, or B) as randomly as possible. ' +
        '<br />(Note that: the "g" key represents "Rock", the "h" key represents "Paper", and the "b" key represents "Scissors". '
    ],
    show_clickable_nav: true,
    data: {
        block_task: 'instructions_block_three'
    }
}

// displays after practice trial is complete
var practice_over = {
    type: 'text',
    text: 'Practice is over! Time for the real thing',
    data: {
        block_task: 'practice_over'
    }
}


/* The following seven blocks are used to display the break images, which are small comic strips
 * Subject is given one minute before trial moves on. Or they can press a key to advance if they are ready sooner.
 */
var break_one = {
    type: 'single-stim',
    stimulus: 'img/Breakim1.png',
    choices: [],
    prompt: '<strong>BREAK</strong>' + '<p>Please enjoy a one minute break.</p>' +
        '<p>Press any key when you are ready to continue</p>',
    timing_response: 60000, // wait 1 minute before continuing
    response_ends_trial: true, // end trial whenever participant presses a key
    data: {
        block_task: 'break_one'
    }
}

var break_two = {
    type: 'single-stim',
    stimulus: 'img/Breakim2.png',
    choices: [],
    prompt: '<strong>BREAK</strong>' + '<p>Please enjoy a one minute break.</p>' +
        '<p>Press any key when you are ready to continue</p>',
    timing_response: 60000, // wait 1 minute before continuing
    response_ends_trial: true, // end trial whenever participant presses a key
    data: {
        block_task: 'break_two'
    }
}

var break_three = {
    type: 'single-stim',
    stimulus: 'img/Breakim3.png',
    choices: [],
    prompt: '<strong>BREAK</strong>' + '<p>Please enjoy a one minute break.</p>' +
        '<p>Press any key when you are ready to continue</p>',
    timing_response: 60000, // wait 1 minute before continuing
    response_ends_trial: true, // end trial whenever participant presses a key
    data: {
        block_task: 'break_three'
    }
}

var break_four = {
    type: 'single-stim',
    stimulus: 'img/Breakim4.png',
    choices: [],
    prompt: '<strong>BREAK</strong>' + '<p>Please enjoy a one minute break.</p>' +
        '<p>Press any key when you are ready to continue</p>',
    timing_response: 60000, // wait 1 minute before continuing
    response_ends_trial: true, // end trial whenever participant presses a key
    data: {
        block_task: 'break_four'
    }
}

var break_five = {
    type: 'single-stim',
    stimulus: 'img/Breakim5.png',
    choices: [],
    prompt: '<strong>BREAK</strong>' + '<p>Please enjoy a one minute break.</p>' +
        '<p>Press any key when you are ready to continue</p>',
    timing_response: 60000, // wait 1 minute before continuing
    response_ends_trial: true, // end trial whenever participant presses a key
    data: {
        block_task: 'break_five'
    }
}

var break_six = {
    type: 'single-stim',
    stimulus: 'img/Breakim6.png',
    choices: [],
    prompt: '<strong>BREAK</strong>' + '<p>Please enjoy a one minute break.</p>' +
        '<p>Press any key when you are ready to continue</p>',
    timing_response: 60000, // wait 1 minute before continuing
    response_ends_trial: true, // end trial whenever participant presses a key
    data: {
        block_task: 'break_six'
    }
}

var break_seven = {
    type: 'single-stim',
    stimulus: 'img/Breakim7.png',
    choices: [],
    prompt: '<strong>BREAK</strong>' + '<p>Please enjoy a one minute break.</p>' +
        '<p>Press any key when you are ready to continue</p>',
    timing_response: 60000, // wait 1 minute before continuing
    response_ends_trial: true, // end trial whenever participant presses a key
    data: {
        block_task: 'break_seven'
    }
}