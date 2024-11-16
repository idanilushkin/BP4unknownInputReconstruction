# BP4unknownInputReconstruction
## MATLAB+Simulink example implementing the backpropagation algorithm to reconstruct the unknown input of a system with distributed parameters, based on a known model and output data
_см. ниже - на русском языке_


**Abstract:**
The task involves reconstructing an unknown signal applied to the input of a dynamic system with distributed parameters. 
A feedforward neural network is used for signal reconstruction. The network is trained by simulating the dynamic system and minimizing the deviation between its output and experimental data. 
After each training epoch, the dynamic model generates a new error vector. The dynamic model is implemented in Simulink, while the backpropagation algorithm is executed through a MATLAB script.

To solve the problem, real-world process data, represented by historical trends, is utilized.

>_To run the example, download the files:_ DataBoiler.mat, createW.m, model.slx, NNadaptInput.m
>
>Simulink Version 8.7 (R2016a)


----

## Пример реализации в MATLAB+Simulink алгоритма восстановления неизвестного входа по известному выходу и модели динамической системы

Решается задача восстановления неизвестного сигнала на входе динамической системы с распределенными параметрами. 
Воспроизведение входного сигнала выполняется с помощью нейронной сети прямого распространения. 
Обучение сети происходит за счёт использования модели динамической системы, путём минимизации отклонения её выхода от экспериментально полученных данных. 
После каждой эпохи обучения выполняется прогон динамической модели для формирования нового вектора ошибки. 
Динамичекая модель реализована в Simulink. Алгоритм обратного распространения ошибки реализован в виде MATLAB скрипта.


>_To run the example, download the files:_ DataBoiler.mat, createW.m, model.slx, NNadaptInput.m
>
>Simulink Version 8.7 (R2016a)
