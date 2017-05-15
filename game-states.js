// initial points for player and computer
var player_points = 100;
var computer_points = 100;

// Game data
var player_wins = 0;
var computer_wins = 0;
var ties = 0;
var forfeits = 0;

// Adjust timing for all game blocks here
var game_timing = 1000;

/* The following ten blocks represent all possible game situations that a player can encounter
 * This approach lacks finesse but it gets the job done. There are 9 possible outcomes if a player
 * submits a response, and 1 outcome if they miss a response (automatic forfeit)
 *
 * FORMAT: PLAYERMOVE_against_COMPUTERMOVE
 * Uses HTML to bootstrap the single-stim plugin
 */
var rock_against_rock = {
    type: 'single-stim',
    is_html: true,
    stimulus: function() {
        return "<div class='left center-content'>" +
            "<p><strong>Points: " + player_points + "</strong></p>" +
            "<p><strong>You</strong></p>" +
            "<img src='img/RPSimage1.png'></img>" +
            "</div>" +
            "<div class='right center-content'>" +
            "<p><strong>Points: " + computer_points + "</strong></p>" +
            "<p><strong>The Computer</strong></p>" +
            "<img src='img/RPSimage1.png'></img>" +
            "</div>";
    },
    choices: [],
    timing_response: game_timing,
    response_ends_trial: false,
    data: {
        block_task: 'rock_against_rock',
        game_status: 'tie'
    }
}

var rock_against_paper = {
    type: 'single-stim',
    is_html: true,
    stimulus: function() {
        return "<div class='left center-content'>" +
            "<p><strong>Points: " + player_points + "</strong></p>" +
            "<p><strong>You</strong></p>" +
            "<img src='img/RPSimage1.png'></img>" +
            "</div>" +
            "<div class='right center-content'>" +
            "<p><strong>Points: " + computer_points + "</strong></p>" +
            "<p><strong>The Computer</strong></p>" +
            "<img src='img/RPSimage2.png'></img>" +
            "</div>";
    },
    choices: [],
    timing_response: game_timing,
    response_ends_trial: false,
    data: {
        block_task: 'rock_against_paper',
        game_status: 'lose'
    }
}

var rock_against_scissors = {
    type: 'single-stim',
    is_html: true,
    stimulus: function() {
        return "<div class='left center-content'>" +
            "<p><strong>Points: " + player_points + "</strong></p>" +
            "<p><strong>You</strong></p>" +
            "<img src='img/RPSimage1.png'></img>" +
            "</div>" +
            "<div class='right center-content'>" +
            "<p><strong>Points: " + computer_points + "</strong></p>" +
            "<p><strong>The Computer</strong></p>" +
            "<img src='img/RPSimage3.png'></img>" +
            "</div>";
    },
    choices: [],
    timing_response: game_timing,
    response_ends_trial: false,
    data: {
        block_task: 'rock_against_scissors',
        game_status: 'win'
    }
}

var paper_against_rock = {
    type: 'single-stim',
    is_html: true,
    stimulus: function() {
        return "<div class='left center-content'>" +
            "<p><strong>Points: " + player_points + "</strong></p>" +
            "<p><strong>You</strong></p>" +
            "<img src='img/RPSimage2.png'></img>" +
            "</div>" +
            "<div class='right center-content'>" +
            "<p><strong>Points: " + computer_points + "</strong></p>" +
            "<p><strong>The Computer</strong></p>" +
            "<img src='img/RPSimage1.png'></img>" +
            "</div>";
    },
    choices: [],
    timing_response: game_timing,
    response_ends_trial: false,
    data: {
        block_task: 'paper_against_rock',
        game_status: 'win'
    }
}

var paper_against_paper = {
    type: 'single-stim',
    is_html: true,
    stimulus: function() {
        return "<div class='left center-content'>" +
            "<p><strong>Points: " + player_points + "</strong></p>" +
            "<p><strong>You</strong></p>" +
            "<img src='img/RPSimage2.png'></img>" +
            "</div>" +
            "<div class='right center-content'>" +
            "<p><strong>Points: " + computer_points + "</strong></p>" +
            "<p><strong>The Computer</strong></p>" +
            "<img src='img/RPSimage2.png'></img>" +
            "</div>";
    },
    choices: [],
    timing_response: game_timing,
    response_ends_trial: false,
    data: {
        block_task: 'paper_against_paper',
        game_status: 'tie'
    }
}

var paper_against_scissors = {
    type: 'single-stim',
    is_html: true,
    stimulus: function() {
        return "<div class='left center-content'>" +
            "<p><strong>Points: " + player_points + "</strong></p>" +
            "<p><strong>You</strong></p>" +
            "<img src='img/RPSimage2.png'></img>" +
            "</div>" +
            "<div class='right center-content'>" +
            "<p><strong>Points: " + computer_points + "</strong></p>" +
            "<p><strong>The Computer</strong></p>" +
            "<img src='img/RPSimage3.png'></img>" +
            "</div>";
    },
    choices: [],
    timing_response: game_timing,
    response_ends_trial: false,
    data: {
        block_task: 'paper_against_scissors',
        game_status: 'lose'
    }
}

var scissors_against_rock = {
    type: 'single-stim',
    is_html: true,
    stimulus: function() {
        return "<div class='left center-content'>" +
            "<p><strong>Points: " + player_points + "</strong></p>" +
            "<p><strong>You</strong></p>" +
            "<img src='img/RPSimage3.png'></img>" +
            "</div>" +
            "<div class='right center-content'>" +
            "<p><strong>Points: " + computer_points + "</strong></p>" +
            "<p><strong>The Computer</strong></p>" +
            "<img src='img/RPSimage1.png'></img>" +
            "</div>";
    },
    choices: [],
    timing_response: game_timing,
    response_ends_trial: false,
    data: {
        block_task: 'scissors_against_rock',
        game_status: 'lose'
    }
}

var scissors_against_paper = {
    type: 'single-stim',
    is_html: true,
    stimulus: function() {
        return "<div class='left center-content'>" +
            "<p><strong>Points: " + player_points + "</strong></p>" +
            "<p><strong>You</strong></p>" +
            "<img src='img/RPSimage3.png'></img>" +
            "</div>" +
            "<div class='right center-content'>" +
            "<p><strong>Points: " + computer_points + "</strong></p>" +
            "<p><strong>The Computer</strong></p>" +
            "<img src='img/RPSimage2.png'></img>" +
            "</div>";
    },
    choices: [],
    timing_response: game_timing,
    response_ends_trial: false,
    data: {
        block_task: 'scissors_against_paper',
        game_status: 'win'
    }
}

var scissors_against_scissors = {
    type: 'single-stim',
    is_html: true,
    stimulus: function() {
        return "<div class='left center-content'>" +
            "<p><strong>Points: " + player_points + "</strong></p>" +
            "<p><strong>You</strong></p>" +
            "<img src='img/RPSimage3.png'></img>" +
            "</div>" +
            "<div class='right center-content'>" +
            "<p><strong>Points: " + computer_points + "</strong></p>" +
            "<p><strong>The Computer</strong></p>" +
            "<img src='img/RPSimage3.png'></img>" +
            "</div>";
    },
    choices: [],
    timing_response: game_timing,
    response_ends_trial: false,
    data: {
        block_task: 'scissors_against_scissors',
        game_status: 'tie'
    }
}

var missed_against_computer = {
    type: 'single-stim',
    is_html: true,
    stimulus: function() {
        return "<div class='left center-content'>" +
            "<p><strong>Points: " + player_points + "</strong></p>" +
            "<p><strong>You</strong></p>" +
            "<p>TOO LATE!</p>" +
            "</div>" +
            "<div class='right center-content'>" +
            "<p><strong>Points: " + computer_points + "</strong></p>" +
            "<p><strong>The Computer</strong></p>" +
            "</div>";
    },
    choices: [],
    timing_response: game_timing,
    response_ends_trial: false,
    data: {
        block_task: 'missed_against_computer',
        game_status: 'forfeit'
    }
}

/* Conditional blocks that will check the last key press and last computer move to find the matching 
 * game state to display. 
 *
 * FORMAT: if_PLAYERMOVE_against_COMPUTERMOVE
 */
var if_rock_against_rock = {
    timeline: [rock_against_rock],
    conditional_function: function() {
        var data = jsPsych.data.getLastTrialData();
        if (data.key_press == 71 && data.answer_status == 'answered' && data.computer_move == 1) {
            ties += 1;
            return true;
        } else {
            return false;
        }
    }
}

var if_rock_against_paper = {
    timeline: [rock_against_paper],
    conditional_function: function() {
        var data = jsPsych.data.getLastTrialData();
        if (data.key_press == 71 && data.answer_status == 'answered' && data.computer_move == 2) {
            computer_wins += 1;
            player_points -= 1;
            computer_points += 1;
            return true;
        } else {
            return false;
        }
    }
}

var if_rock_against_scissors = {
    timeline: [rock_against_scissors],
    conditional_function: function() {
        var data = jsPsych.data.getLastTrialData();
        if (data.key_press == 71 && data.answer_status == 'answered' && data.computer_move == 3) {
            player_wins += 1;
            player_points += 1;
            computer_points -= 1;
            return true;
        } else {
            return false;
        }
    }
}

var if_paper_against_rock = {
    timeline: [paper_against_rock],
    conditional_function: function() {
        var data = jsPsych.data.getLastTrialData();
        if (data.key_press == 72 && data.answer_status == 'answered' && data.computer_move == 1) {
            player_wins += 1;
            player_points += 1;
            computer_points -= 1;
            return true;
        } else {
            return false;
        }
    }
}

var if_paper_against_paper = {
    timeline: [paper_against_paper],
    conditional_function: function() {
        var data = jsPsych.data.getLastTrialData();
        if (data.key_press == 72 && data.answer_status == 'answered' && data.computer_move == 2) {
            ties += 1;
            return true;
        } else {
            return false;
        }
    }
}

var if_paper_against_scissors = {
    timeline: [paper_against_scissors],
    conditional_function: function() {
        var data = jsPsych.data.getLastTrialData();
        if (data.key_press == 72 && data.answer_status == 'answered' && data.computer_move == 3) {
            computer_wins += 1;
            player_points -= 1;
            computer_points += 1;
            return true;
        } else {
            return false;
        }
    }
}

var if_scissors_against_rock = {
    timeline: [scissors_against_rock],
    conditional_function: function() {
        var data = jsPsych.data.getLastTrialData();
        if (data.key_press == 66 && data.answer_status == 'answered' && data.computer_move == 1) {
            computer_wins += 1;
            player_points -= 1;
            computer_points += 1;
            return true;
        } else {
            return false;
        }
    }
}

var if_scissors_against_paper = {
    timeline: [scissors_against_paper],
    conditional_function: function() {
        var data = jsPsych.data.getLastTrialData();
        if (data.key_press == 66 && data.answer_status == 'answered' && data.computer_move == 2) {
            player_wins += 1;
            player_points += 1;
            computer_points -= 1;
            return true;
        } else {
            return false;
        }
    }
}

var if_scissors_against_scissors = {
    timeline: [scissors_against_scissors],
    conditional_function: function() {
        var data = jsPsych.data.getLastTrialData();
        if (data.key_press == 66 && data.answer_status == 'answered' && data.computer_move == 3) {
            ties += 1;
            return true;
        } else {
            return false;
        }
    }
}

var if_missed_against_computer = {
    timeline: [missed_against_computer],
    conditional_function: function() {
        var data = jsPsych.data.getLastTrialData();
        if (data.key_press == -1) {
            forfeits += 1;
            player_points -= 1;
            return true;
        } else {
            if (data.condition == "unaware_no_predict") {
                var comp_move = computerRandomMove();
            } else {
                var comp_move = (predictNextPlay() % 3) + 1;
            }
            jsPsych.data.addDataToLastTrial({
                computer_move: comp_move
            })
            return false;
        }
    }
}
