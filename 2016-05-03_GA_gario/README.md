
![preview](preview.png?raw=true preview)
![preview](preview.gif?raw=true preview)
---

##Usage
```java
// create a new population wrapper with a pool 
// of 100 organisms, and a mutation rate of 0.1%
population = new Population(100, 0.01);

// handle the fitness of each organism in 
// the population pool
for(Organism o : population.ORGANISMS) o.FITNESS = newFitness;

population.display();
population.displayHistory();

// evolve the population to the next generation with
population.evolve();

// ... or 
population.pushHistory();
population.populate_pool();
population.reproduce();

```


##Reference
```java
public class Population
    public Organism[] ORGANISMS
    public ArrayList<Organism> MATING_POOL
    public int GENERATION
    public float MUTATION_RATE

    public void display()
    public void selection()
    public void reproduction()

public class Organism
    public Dna DNA
    public void display()

public class Dna
    public float[] Dna.GENES

    public Dna()
    private Dna(float[] new_genes)

    public Dna recombinate(Dna partner)
    public void mutate(float mutation_rate)
```

-
*based on The Nature of Code by Daniel Shiffman : http://natureofcode.com*

---
*Arnaud Juracek*, `GNU GENERAL PUBLIC LICENSE Version 3, June 2007`
