
const frames = {
    framesTest1 : ["5/", "x", "1-", "--", "--", "--", "--", "--", "--", "--"], //32
    framesTest2 : ["5/", "x", "1-", "x", "x", "2/", "9-", "9-", "--", "--"], //111
    framesTest3 : ["5/", "x", "1-", "x", "x", "2/", "9-", "9-", "-/", "--"], //121   
    framesTest4 : ["x", "x", "x", "x", "x", "x", "x", "x", "x", "x", "x", "x"], //300 
    framesTest5 : ["9-", "9-", "9-", "9-", "9-", "9-", "9-", "9-", "9-", "9-"], //90 
    framesTest6 : ["5/", "5/", "5/", "5/", "5/", "5/", "5/", "5/", "5/", "5/", "50"] //150
};

let i = 1;
for (const [frameName, testFrames] of Object.entries(frames)) {
    document.getElementById('frames').innerHTML += '<div><button id="framesTest'+i+'">Test</button> '+testFrames+'</div>';
    i++
}

document.addEventListener('click', function (event) {
    if (event.target.matches('button')){
        calcScore(frames[event.target.id]);
    }
}, false);