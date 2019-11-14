const express = require('express');
const morgan = require('morgan');
const app = express();

// http://10.226.7.52:3000/players/597b7f10

app.use(morgan('common'));

function is_perfect_square(n) {
  if (n < 0)
      return false;
  const root = Math.round(Math.sqrt(n));
  return n == root * root;
}

function is_perfect_cube(n) {
  const root = Math.round(Math.cbrt(n));
  return n == root * root * root;
}

function isPrime(num) {
  for(var i = 2; i < num; i++)
    if(num % i === 0) return false;
  return num > 1;
}

function fibonacci(num){
  var a = 1, b = 0, temp;
  while (num >= 0){
    temp = a;
    a = a + b;
    b = temp;
    num--;
  }
  return b;
}

const isAnagram = (str1, str2) => {
  let str1Count = {};
  let str2Count = {};

  if (str1.length === str2.length) {
    for (let i in str1) {
      checker(str1[i], str1Count);
      checker(str2[i], str2Count);
    }
    return areEqualObjects(str1Count, str2Count);
  } else {
    return false
  }
}
const checker = (letter, obj) => {
  if (obj[letter] === undefined) {
    return obj[letter] = 1
  } else {
    return obj[letter] += 1
  }
}
const areEqualObjects = (obj1, obj2) => {
  for (let el in obj1) {
    if (obj1[el] !== obj2[el]){
      return false
    }
  }
  return true
}

function scrabbleScore(word) {
  word = word.toUpperCase();
var alphabet = {
    A: 1,
    B: 3,
    C: 3,
    D: 2,
    E: 1,
    F: 4,
    G: 2,
    H: 4,
    I: 1,
    J: 8,
    K: 5,
    L: 1,
    M: 3,
    N: 1,
    O: 1,
    P: 3,
    Q: 10,
    R: 1,
    S: 1,
    T: 1,
    U: 1,
    V: 4,
    W: 4,
    X: 8,
    Y: 4,
    Z: 10
}
var letter, i, sum = 0;
for (i = 0; i < word.length; i++) {
    letter = word[i];
    sum += alphabet[letter];
}
return sum;
}
app.get('*', (req, res) => {
  console.log('  request.query', req.query);
  console.log('  request.headers', req.headers);

  try {
    
  const match = req.query && req.query.q && req.query.q.match(/^([0-9a-z]*):\s(.*)$/);
  const question = match && match.length > 1 && match[2];

  if(!question) {
    res.send('no question');
  }

  if(question.indexOf('hvilken by er hovedstaden i Norge') >= 0) {
    res.send('Oslo');
  } else if(question.indexOf('hvilken by er hovedstaden i Frankrike') >= 0) {
    res.send('Paris');
  } else if(question.indexOf('hvor mange banker er det i SB1 alliansen') >= 0) {
    res.send('14');
  } else if(question.indexOf('hvem spilte James Bond i Dr No') >= 0) {
    res.send('Sean Connery');
  } else if(question.indexOf('Fibonacci sequence') >= 0) {
    const match = question.match(/(\d+)/);
    res.send('' + fibonacci(parseInt(match[1]) - 1))
  } else if(question.indexOf('to the power of') >= 0) {
    const match = question.match(/what is (\d+) to the power of (\d+)/);
    res.send('' + BigInt(Math.pow(parseInt(match[1]), parseInt(match[2]))).toString());
  } else if (question.indexOf('which of the following numbers are primes') >= 0) {
    const numbers = match[2].split(': ')[1].split(',').map(i => parseInt(i));
    const matches = numbers.filter(number => isPrime(number));
    res.send('' + matches.join(', '));
  } else if (question.indexOf('which of the following numbers is the largest') >= 0) {
    const numbers = match[2].split(': ')[1].split(',').sort().map(i => parseInt(i));
    res.send('' + Math.max(...numbers));
  } else if(question.indexOf('which of the following is an anagram of') >= 0) {
    const match = question.match(/which of the following is an anagram of "([a-zA-Z]+)": ([a-zA-Z\s,]+)/);
    if(match) {
      const word = match[1];
      const words = match[2].split(',');
      console.log(word);
      console.log(words);
      const filtered = words.filter(testword => isAnagram(word, testword.trim()));
      res.send('' + filtered.join(', '));
    } else {
      res.send('what?');
    }
  } else if(question.indexOf('scrabble score') >= 0) {
    const match = question.match(/what is the english scrabble score of ([a-zA-Z]+)/);
    res.send('' + scrabbleScore(match[1]));
  } else if(question.indexOf('which of the following numbers is both a square and a cube') >= 0) {
    const numbers = match[2].split(': ')[1].split(',').map(i => parseInt(i));
    const answer = numbers.filter(number => is_perfect_square(number) && is_perfect_cube(number));
    res.send('' + answer.join(','));
  } else if (question.indexOf('what is') >= 0) {

    const match1 = question.match(/what is (\d+) plus (\d+) multiplied by (\d+)/);
    const match2 = question.match(/what is (\d+) plus (\d+) plus (\d+)/);
    const match3 = question.match(/what is (\d+) multiplied by (\d+) plus (\d+)/);

    if(match1) {
      const result = parseInt(match1[1]) + parseInt(match1[2]) * parseInt(match1[3])
      res.send('' + result);
    } else if(match2) {
      const result = parseInt(match2[1]) + parseInt(match2[2]) + parseInt(match2[3])
      res.send('' + result);
    } else if(match3) {
      const result = parseInt(match3[1]) * parseInt(match3[2]) + parseInt(match3[3])
      res.send('' + result);
    }else if (match[2].indexOf('plus') >= 0) {
      const numbers = match[2].match(/(\d+)\splus\s(\d+)/);
      res.send('' + (parseInt(numbers[1]) + parseInt(numbers[2])));
    } else if (match[2].indexOf('minus') >= 0) {
      const numbers = match[2].match(/(\d+)\sminus\s(\d+)/);
      res.send('' + (parseInt(numbers[1]) - parseInt(numbers[2])));
    
    } else if(match[2].indexOf('multiplied by') >= 0) {
      const numbers = match[2].match(/(\d+)\smultiplied by\s(\d+)/);
      res.send('' + (parseInt(numbers[1]) * parseInt(numbers[2])));
    }
  } else {
    res.send('OK');
  }  
} catch(e) {
  res.send('' + e.message);
}
});

module.exports = app;
