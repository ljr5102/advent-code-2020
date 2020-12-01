const { each } = require("lodash");
const fs = require("fs");

const readInput = () => {
  return fs.readFile("./input.txt", "utf-8", (err, data) => {
    if (err) {
      console.log(err)
      return [];
    }
    const formatted = data.split("\n").filter(el => el !== "").map(el => parseInt(el))

    console.log("Two Entries Result: ", twoEntries2020(formatted))
    console.log("Three Entries Result: ", threeEntries2020(formatted))
  })
}

const twoEntries2020 = (input) => {
  const seenValues = new Set();
  let result = null;

  each(input, (el) => {
    const neededValue = 2020 - el;

    if (seenValues.has(neededValue)) {
      result = el * neededValue
      return
    }
    seenValues.add(el);
  })
  return result;
}

const threeEntries2020 = (input) => {
  const seenValues = new Set();
  let result = null;

  each(input, (el, idx) => {
    each(input.slice(idx + 1), (elTwo) => {
      const neededValue = 2020 - elTwo - el;
      if (seenValues.has(neededValue)) {
        result = el * elTwo * neededValue;
        return
      }
      seenValues.add(elTwo)
    })
    seenValues.add(el);
  })
  return result;
}

readInput();
