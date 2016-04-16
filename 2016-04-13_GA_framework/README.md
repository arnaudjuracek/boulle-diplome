
![preview](preview.png?raw=true preview)
---
```java
public class Population
    public Organism[] ORGANISMS
    public ArrayList<Organism> MATING_POOL
    public int GENERATION
    public float MUTATION_RATE

    public void display()
    public void selection()
    public void reproduction()

class Organism
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
