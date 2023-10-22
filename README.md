# Mutual Subspace Methods Repository

This repository hosts a collection of mutual subspace methods and their implementations. 

## Methods
- [x] Mutual Subspace Method (MSM)
- [ ] Constraint Mutual Subspace method (CMSM)
- [ ] Orthogonal Mutual subspace method (OMSM)
- [x] Kernel Mutual Subspace Method (KMSM)
- [ ] Kernel Constraint Mutual Subspace method (KCMSM)
- [ ] Kernel Orthogonal Mutual subspace method (KOMSM)
- [ ] Random Fourier Features MSM (RFFMSM)
- [ ] K-means KOMSM
- [ ] RFF + K-means KOMSM

## Sample Implementation
Below is a sample implementation for the Mutual Subspace Method (MSM):

## Datasets Used
1. CVLabFace
2. TsukubaHand24x24
Each example implementation is available in files named as `example_(name_of_the_method).m`.

## Further Reading
If you are interested in learning more about these methods, consider reviewing the following papers:
```matlab
reference_subspaces = cvlBasisVector(training_data, num_dim_reference_subspaces);
input_subspaces = cvlBasisVector(testing_data, num_dim_input_subspace);
similarities = cvlCanonicalAngles(reference_subspaces,input_subspaces);
accuracy = cvlComputeAccuracy(similarities, num_sets, num_classes);

fprintf('Accuracy MSM: %.2f%%\n', accuracy * 100);
```


### Basics of Subspace Methods
- [Subspace Methods](http://www.cvlab.cs.tsukuba.ac.jp/~kfukui/english/epapers/subspace_method.pdf)
              
### CMSM, OMSM, KCMSM, KOMSM
- [Comparison between Constrained Mutual Subspace Method and Orthogonal Mutual Subspace Method](https://www.cs.tsukuba.ac.jp/internal/techreport/data/CS-TR-06-7.pdf)
- [Face Recognition with the Multiple Constrained Mutual Subspace Method](http://www.cvlab.cs.tsukuba.ac.jp/~kfukui/english/epapers/AVBPA05.pdf)

### Kmeans KOMSM
- [Hand Shape Recognition based on Kernel Orthogonal Mutual Subspace Method ](http://www.cvlab.cs.tsukuba.ac.jp/~kfukui/english/epapers/MVA2009.pdf)

---

Feel free to explore and contribute to the repository!
