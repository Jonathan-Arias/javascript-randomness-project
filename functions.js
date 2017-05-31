/* Binomial Distribution Function Calculator
 * Author: Thomas Ferguson
 * Source: http://www.math.ucla.edu/~tom/distributions/binomial.html
 */

function LogGamma(Z) {
    with(Math) {
        var S = 1 + 76.18009173 / Z - 86.50532033 / (Z + 1) + 24.01409822 / (Z + 2) - 1.231739516 / (Z + 3) + .00120858003 / (Z + 4) - .00000536382 / (Z + 5);
        var LG = (Z - .5) * log(Z + 4.5) - (Z + 4.5) + log(S * 2.50662827465);
    }
    return LG
}

function Betinc(X, A, B) {
    var A0 = 0;
    var B0 = 1;
    var A1 = 1;
    var B1 = 1;
    var M9 = 0;
    var A2 = 0;
    var C9;
    while (Math.abs((A1 - A2) / A1) > .00001) {
        A2 = A1;
        C9 = -(A + M9) * (A + B + M9) * X / (A + 2 * M9) / (A + 2 * M9 + 1);
        A0 = A1 + C9 * A0;
        B0 = B1 + C9 * B0;
        M9 = M9 + 1;
        C9 = M9 * (B - M9) * X / (A + 2 * M9 - 1) / (A + 2 * M9);
        A1 = A0 + C9 * A1;
        B1 = B0 + C9 * B1;
        A0 = A0 / B1;
        B0 = B0 / B1;
        A1 = A1 / B1;
        B1 = 1;
    }
    return A1 / A
}

function compute(argument, samplesize, prob) {
    X = argument;
    N = samplesize;
    P = prob;
    with(Math) {
        /*if (N <= 0) {
            alert("sample size must be positive")
        } else if ((P < 0) || (P > 1)) {
            alert("probability must be between 0 and 1")
        } else*/
        if (X < 0) {
            bincdf = 0
        } else if (X >= N) {
            bincdf = 1
        } else {
            X = floor(X);
            Z = P;
            A = X + 1;
            B = N - X;
            S = A + B;
            BT = exp(LogGamma(S) - LogGamma(B) - LogGamma(A) + A * log(Z) + B * log(1 - Z));
            if (Z < (A + 1) / (S + 2)) {
                Betacdf = BT * Betinc(Z, A, B)
            } else {
                Betacdf = 1 - BT * Betinc(1 - Z, B, A)
            }
            bincdf = 1 - Betacdf;
        }
        bincdf = round(bincdf * 100000) / 100000;
    }
    return bincdf;
}


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

var globalMove = 0;

// 85% of the time will follow R-P-S-R-P-S... 
// 15% will generate random move
function computerRandomMove() {
    let x = Math.random();
    if (x <= 0.15) {
        return Math.floor(Math.random() * 3) + 1;
    } else {
        return globalMove % 3 + 1;
    }
}

// collects simple data about responses and returns totals for number of 
// answered/missed and RPS selections
function getSubjectData() {
    let trials = jsPsych.data.getTrialsOfType('single-stim');

    let total_answered = 0;
    let total_missed = 0;
    let total_rock = 0;
    let total_paper = 0;
    let total_scissor = 0;
    for (let i = 0; i < trials.length; i++) {
        if (trials[i].answer_status == 'answered') {
            total_answered++;
            if (trials[i].key_press == 71) { // 71 == 'g' == Rock 
                total_rock++;
            } else if (trials[i].key_press == 72) { // 72 == 'h' == Paper
                total_paper++;
            } else if (trials[i].key_press == 66) { // 66 == 'b' == Scissors
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

// Sequence is generated with 1 representing Rock, 2 representing Paper, 3 representing Scissors
// e.g. Rock-Paper-Scissors-Scissors-Paper-Scissors-Paper-Rock 
// would become 12332321
// trialnum parameter can only be 1 2 or 3, will return empty string otherwise
function collectTrialSequence(trialnum) {
    let trials = jsPsych.data.getTrialsOfType('single-stim');
    let sequence = '';

    if (trialnum == 1 || trialnum == 3) {
        for (let i = 0; i < trials.length; i++) {
            if (trials[i].trial_data == trialnum) {
                if (trials[i].block_task == 'rock_image') {
                    sequence += '1';
                } else if (trials[i].block_task == 'paper_image') {
                    sequence += '2';
                } else if (trials[i].block_task == 'scissors_image') {
                    sequence += '3';
                }
            }
        }
    } else if (trialnum == 2) {
        for (let i = 0; i < trials.length; i++) {
            if (trials[i].trial_data == 2) {
                if (trials[i].block_task == 'rock_against_rock' || trials[i].block_task == 'rock_against_paper' || trials[i].block_task == 'rock_against_scissors') {
                    sequence += '1';
                } else if (trials[i].block_task == 'paper_against_rock' || trials[i].block_task == 'paper_against_paper' || trials[i].block_task == 'paper_against_scissors') {
                    sequence += '2';
                } else if (trials[i].block_task == 'scissors_against_rock' || trials[i].block_task == 'scissors_against_paper' || trials[i].block_task == 'scissors_against_scissors') {
                    sequence += '3';
                }
            }
        }
    }

    return sequence;
}

// Using collectTrialSequence(trialnum), returns one string with entire sequence
// Should only be used at end of experiment, otherwise results in unneccesary function calls
function collectAllSequences() {
    let s1 = collectTrialSequence(1);
    let s2 = collectTrialSequence(2);
    let s3 = collectTrialSequence(3);

    let full_sequence = (s1 + s2 + s3);
    return full_sequence;
}

// Returns an object with game data
function collectWinLossTieProportion() {
    return {
        wins: player_wins,
        losses: computer_wins,
        ties: ties,
        forfeits: forfeits
    }
}

// See http://stackoverflow.com/questions/5667888/counting-the-occurrences-of-javascript-array-elements 
// for more info about this function
// Takes a string, collects frequency of each element into object, returns object as a string
// e.g. 11223311
// Returns {1: 4, 2: 2, 3: 2}
function condenseSequenceIntoObject(sequence) {
    let arr = [...sequence];
    var result = {};
    for (var i = 0; i < arr.length; i++) {
        if (!result[arr[i]])
            result[arr[i]] = 0;
        ++result[arr[i]];
    }
    var str = JSON.stringify(result);
    return str;
}

// Displays frequency of each event that subject has entered in console
function displayRPSCountInConsole(trialnum) {
    if (trialnum <= 0 || trialnum > 3) {
        console.log("You must use a number between 1 and 3 for displayRPSCountInConsole function to work properly");
    }
    let sequence = collectTrialSequence(trialnum);
    let condensed = condenseSequenceIntoObject(sequence);
    console.log("Part " + trialnum);
    console.log(condensed);
}

// Used for computerRunLength()
// current is the event observed 
// count is the frequency observed
// Returns apprpropriate letter ("R" == Rock == 1, "P" == Paper == 2, "S" == Scissors == 3) appended to count
function runLengthHelper(count, current) {
    let buffer = "";
    if (current == 1) {
        buffer = count + "R";
    } else if (current == 2) {
        buffer = count + "P";
    } else if (current == 3) {
        buffer = count + "S";
    }
    return buffer;
}

// Given the entire sequence from experiment, processes run length for each event in string
// e.g. 11112231231333332
// Returns 4R2P1S1R1P1S1R5S1P
function computeRunLength() {
    let str = collectAllSequences();

    let count = 0;
    let current = -1;
    let runLength = [];
    let buffer = "";

    for (let i = 0; i <= str.length; i++) {

        // Reached end of string, add last element count
        if (i == str.length) {
            if (count >= 1) {
                buffer = runLengthHelper(count, current);
                runLength.push(buffer);
                break;
            }
        }

        // First element in sequence
        if (count == 0) {
            current = str[i];
            count++;
        } else if (current == str[i]) {
            count++;
        } else if (current != str[i]) {
            buffer = runLengthHelper(count, current);
            runLength.push(buffer);
            count = 1;
            current = str[i];
        }
    }

    return runLength;
}

// Predict the user's next most likely response in RPS, will output random move if confidence level is below threshold
// This is used in the if_missed_against_computer conditional block, and will only be called if the user did not miss 
// against the computer in trial 2
function predictNextPlay() {
    var str = collectTrialSequence(1) + collectTrialSequence(2);

    if (str.length == 0) {
        return computerRandomMove();
    }

    var N = 20;
    var choices = [];

    var possibleEntries = [1, 2, 3];
    var nPossibleEntries = 3;
    var alphaLevel = 1 / nPossibleEntries;

    for (var k = 1; k <= 20; k++) {
        var re = new RegExp(str.substr(-k), 'g');
        var m;
        var matches = [];

        do {
            m = re.exec(str.substr(0, str.length - 1));
            if (m) {
                matches.push(m.index + 1);
            } else {
                break;
            }
        } while (m);

        if (matches.length == 0) {
            break;
        }

        var entry;
        var rks = ppr = scs = 0;
        for (entry in matches) {
            x = parseInt(str.charAt(matches[entry] + k - 1));
            if (x == 1) rks++;
            if (x == 2) ppr++;
            if (x == 3) scs++;
        }
        choices.push([rks, ppr, scs]);
    }

    var pVals = [];
    var mins;
    var choice;
    var X, N, P;
    var bcf;
    for (var i = 0; i < choices.length; i++) {
        choice = choices[i];
        X = Math.max(...choice) - 1;
        N = choice[0] + choice[1] + choice[2];
        P = 1 / nPossibleEntries;
        bcf = compute(X, N, P);
        pVals[i] = 1 - bcf;
    }

    var predictConfidence = Math.min(...pVals);
    if (predictConfidence >= alphaLevel) {
        return (Math.floor(Math.random() * 3) + 1);
    } else {
        var ind = pVals.indexOf(predictConfidence);
        var i = choices[ind].indexOf(Math.max(...choices[ind]));
        var nextItem = possibleEntries[i];
    }

    return nextItem;
}
