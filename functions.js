// function to check for participant consent
var check_consent = function(elem) {
    if ($('#consent_checkbox').is(':checked')) {
        return true;
    } else {
        alert("If you wish to participate, you must check the box next to the statement 'I agree to participate in this study.'");
        return false;
    }
    return false;
}

function computerRandomMove() {
    // 1 == Rock, 2 == Paper, 3 == Scissors
    // Math.random() generates a random decimal, so multiplying it by 3 will get a range of 0 <= val < 3
    // Math.floor() rounds down the number to its nearest whole number, range now 0 <= val <= 2
    // Adding 1 will shift the range to be 1 <= val <= 3
    return Math.floor(Math.random() * 3) + 1;
}

// collects simple data about responses and returns totals for number of answered/missed and RPS selections
function getSubjectData() {
    var trials = jsPsych.data.getTrialsOfType('single-stim');

    var total_answered = 0;
    var total_missed = 0;
    var total_rock = 0;
    var total_paper = 0;
    var total_scissor = 0;
    for (var i = 0; i < trials.length; i++) {
        if (trials[i].answer_status == 'answered') {
            total_answered++;
            if (trials[i].key_press == 71) {
                total_rock++;
            } else if (trials[i].key_press == 72) {
                total_paper++;
            } else if (trials[i].key_press == 66) {
                total_scissor++;
            }
        } else if (trials[i].answer_status == 'missed') {
            total_missed++;
        }
    }
    return {
        rock: total_rock,
        paper: total_paper,
        scissor: total_scissor,
        answered: total_answered,
        missed: total_missed
    }
}

function collectTrialOneSequence() {
    var trials = jsPsych.data.getTrialsOfType('single-stim');

    var sequence = '';
    for (var i = 0; i < trials.length; i++) {
        if (trials[i].trial_data == 1) {
            if (trials[i].block_task == 'rock_image') {
                sequence += '1';
            } else if (trials[i].block_task == 'paper_image') {
                sequence += '2';
            } else if (trials[i].block_task == 'scissors_image') {
                sequence += '3';
            }
        }
    }
    return {
        trial_one_sequence: sequence
    }
}

function collectTrialTwoSequence() {
    var trials = jsPsych.data.getTrialsOfType('single-stim');

    var sequence = '';
    for (var i = 0; i < trials.length; i++) {
        if (trials[i].trial_data == 2) {
            if (trials[i].block_task == 'rock_image') {
                sequence += '1';
            } else if (trials[i].block_task == 'paper_image') {
                sequence += '2';
            } else if (trials[i].block_task == 'scissors_image') {
                sequence += '3';
            }
        }
    }
    return {
        trial_two_sequence: sequence
    }
}

function collectTrialThreeSequence() {
    var trials = jsPsych.data.getTrialsOfType('single-stim');

    var sequence = '';
    for (var i = 0; i < trials.length; i++) {
        if (trials[i].trial_data == 3) {
            if (trials[i].block_task == 'rock_image') {
                sequence += '1';
            } else if (trials[i].block_task == 'paper_image') {
                sequence += '2';
            } else if (trials[i].block_task == 'scissors_image') {
                sequence += '3';
            }
        }
    }
    return {
        trial_three_sequence: sequence
    }
}

function collectAllSequences() {
    var s1 = collectTrialOneSequence();
    var s2 = collectTrialTwoSequence();
    var s3 = collectTrialThreeSequence();

    var sequence = '';
    sequence += s1.trial_one_sequence + s2.trial_two_sequence + s3.trial_three_sequence;
    return {
        complete_sequence: sequence
    }
}