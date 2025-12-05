
fn main() {
    let path = "input.txt";
    let content = std::fs::read_to_string(path).expect("Failed to read file");
    
    let mut zeroCounter = 0;
    let mut zeroClickCounter = 0;
    let startValue = 50;
    let mut currentValue = startValue;
    let valueRange = 100;
    
    for line in content.lines() {
        let length = line.len();
        if length <= 1
        {
            continue;
        }
        let tail = &line[1..length];
        let step: i32 = tail.parse().unwrap();

        let mut directionFactor: i32;
        if line.chars().nth(0).unwrap() == 'R'
        {
            directionFactor = 1;
 
            let zeroClicks = (step + currentValue) / valueRange;
            zeroClickCounter += zeroClicks;
        }
        else
        {
            directionFactor = -1;
            if (step >= currentValue)
            {
                let mut zeroClicks = 0;
                if currentValue == 0
                {
                    zeroClicks = ((step + (valueRange - currentValue)) / valueRange) -1;
                }
                else
                {
                    zeroClicks = (step + (valueRange - currentValue)) / valueRange;
                }
                zeroClickCounter += zeroClicks;
            }
        }

        currentValue = (currentValue + directionFactor * step).rem_euclid(valueRange);
        if currentValue == 0
        {
            zeroCounter += 1;
        }

    }
    println!("The code (solution part 1) is: {}", zeroCounter);
    println!("The code (solution part 2) is {}", zeroClickCounter);
}
