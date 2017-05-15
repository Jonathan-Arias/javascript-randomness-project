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
        if (N <= 0) {
            alert("sample size must be positive")
        } else if ((P < 0) || (P > 1)) {
            alert("probability must be between 0 and 1")
        } else if (X < 0) {
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
            if (trials[i].block_task == 'rock_against_rock' || trials[i].block_task == 'rock_against_paper' || trials[i].block_task == 'rock_against_scissors') {
                sequence += '1';
            } else if (trials[i].block_task == 'paper_against_rock' || trials[i].block_task == 'paper_against_paper' || trials[i].block_task == 'paper_against_scissors') {
                sequence += '2';
            } else if (trials[i].block_task == 'scissors_against_rock' || trials[i].block_task == 'scissors_against_paper' || trials[i].block_task == 'scissors_against_scissors') {
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
function condenseSequenceIntoObject(sequence) {
    let arr = [...sequence];
    result = {};
    for (var i = 0; i < arr.length; i++) {
        if (!result[arr[i]])
            result[arr[i]] = 0;
        ++result[arr[i]];
    }
    str = JSON.stringify(result);
    return {
        str: str
    }
}

function displayRPSCountInConsole(trialnum) {
    if (trialnum == 1) {
        var s1 = collectTrialOneSequence();
        var c = condenseSequenceIntoObject(s1.trial_one_sequence);
        console.log("Part 1");
        console.log(c.str);
    }
    if (trialnum == 2) {
        var s2 = collectTrialTwoSequence();
        var c = condenseSequenceIntoObject(s2.trial_two_sequence);
        console.log("Part 2");
        console.log(c.str);
    }
    if (trialnum == 3) {
        var s3 = collectTrialThreeSequence();
        var c = condenseSequenceIntoObject(s3.trial_three_sequence);
        console.log("Part 3");
        console.log(c.str);
    }
    if (trialnum <= 0 || trialnum > 3) {
        console.log("You must use a number between 1 and 3 for displayRPSCountInConsole function to work properly");
    }
}

function computeRunLength() {
    var a = collectAllSequences();
    var str = a.complete_sequence;

    var count = 0;
    var current = -1;
    var arr = [];
    var buffer = "";

    for (var i = 0; i <= str.length; i++) {
        if (i == str.length) {
            if (count >= 1) {
                if (current == 1) {
                    buffer = count + "R";
                    arr.push(buffer);
                } else if (current == 2) {
                    buffer = count + "P";
                    arr.push(buffer);
                } else if (current == 3) {
                    buffer = count + "S";
                    arr.push(buffer);
                }
                break;
            }
        }

        if (count == 0) {
            current = str[i];
            count++;
        } else if (current == str[i]) {
            count++;
        } else if (current != str[i]) {
            if (current == 1) {
                buffer = count + "R";
                arr.push(buffer);
            } else if (current == 2) {
                buffer = count + "P";
                arr.push(buffer);
            } else if (current == 3) {
                buffer = count + "S";
                arr.push(buffer);
            }
            count = 1;
            current = str[i];
        }
    }

    return {
        runarray: arr
    }
}

// Used to generate predictions solely from part 1 sequence
function predictNextPlay() {
    var seq1 = collectTrialOneSequence();
    var str = seq1.trial_one_sequence;
    var seq2 = collectTrialTwoSequence();
    var str2 = seq2.trial_two_sequence;
    str += str2;

    if (str.length == 0) {
        return computerRandomMove();
    }

    var N = 20;
    var choices = [];

    var nPossibleEntries = 3;
    var alphaLevel = 1/nPossibleEntries;

    for (var k = -1; k > -20; k--)
    {
        var re = new RegExp(str.substr(k),'g');
        var m;
        var matches = [];

        do {
            m = re.exec(str.substr(0,str.length+k));
            if (m)
            {
                matches.push(m.index);
            } else {
                break;
            }
        } while (m);

        if (matches.length == 0)
        {
            break;
        }

        var entry;
        var rks = ppr = scs = 0;
        for (entry in matches){
            x = parseInt(str.charAt(matches[entry]+1));
            if (x == 1) rks++;
            if (x == 2) ppr++;
            if (x == 3) scs++;
        }
        choices.push([rks,ppr,scs]);
    }

    var pVals = [];
    var mins;
    var choice;
    var X, N, P;
    var bcf;
    for (var i = 0; i < choices.length; i++){
        choice = choices[i];
        X = Math.max(...choice);
        N = choice[0] + choice[1] + choice[2];
        P = 1/nPossibleEntries;
        bcf = compute(X,N,P);
        pVals[i] = 1 - bcf;
    }

    var predictConfidence = Math.min(...pVals);
    if (predictConfidence >= alphaLevel)
    {
        return computerRandomMove();
    } else 
    {
        var ind = pVals.indexOf(predictConfidence);
        var nextItem = Math.max(...choices[ind]);
    }


    return nextItem;
}
