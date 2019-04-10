function calcScore(frames){
    let score = 0;
    for (let i = 0; i <10; i++){
        const frame = frames[i];
        score += getBaseScore(frame);
        if (frame.length === 1){ //se 2 frame frem
            score += getBonusScore(frames[i+1],frames[i+2],'strike');
        }else if(frame.indexOf('/')===1){ //se 1 frame frem
            score += getBonusScore(frames[i+1],null,'spare');
        }
    }
    document.getElementById('score').innerHTML = score;
}

function getBaseScore(frame){
    if (frame.length === 1 || frame.indexOf('/')===1){
        return 10;
    }else{
        const frameRolls = frame.split('');
        return rollScore(frameRolls[0]) + rollScore(frameRolls[1]);
    }
}

function getBonusScore(frameNext,frameNextNext,type){
    if (type==='spare'){
        if(frameNext.length===2){
            const frameRolls = frameNext.split('');
            return rollScore(frameRolls[0]);
        }
        return 10;
    }else{
        if(frameNext.length===2){
            if(frameNext.indexOf('/')===1) return 10;
            const frameRolls = frameNext.split('');
            return rollScore(frameRolls[0]) + rollScore(frameRolls[1]);
        }
        const frameRolls = frameNextNext.split('');
        return 10 + rollScore(frameRolls[0]);
    }
}

function rollScore(roll){
    switch(roll) {
        case 'x':
            return 10;
        case '-':
            return 0;
        default:
          return parseInt(roll);
      }
}