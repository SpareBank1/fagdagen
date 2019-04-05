import numpy as np
from sklearn.preprocessing import LabelBinarizer
from keras.models import load_model

model = load_model('bowling.h5')

encoder = LabelBinarizer().fit([0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10])
onehot_size = len(encoder.classes_)

tre_runder = [[10, 0, 10, 0, 10, 0],
                [10, 0, 10, 0, 6, 0],
                [10, 0, 10, 0, 7, 0],
                [10, 0, 10, 0, 8, 0],
                [2, 8, 7, 1, 9, 0],
                [1, 9, 10, 0, 10, 0]]
feature_vector_length = len(tre_runder[0]) * onehot_size

pred_input = encoder.transform(np.array(tre_runder).flatten()).reshape(len(tre_runder), feature_vector_length)
prediction = model.predict(pred_input)
for i in range(len(tre_runder)):
    for j in range(31):
        if prediction[i][j] > 0.9:
            print(j)
