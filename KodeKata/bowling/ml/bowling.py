import pandas as pd
import numpy as np
import time
from keras.layers import Dense
from keras import Sequential, callbacks
from sklearn.preprocessing import LabelBinarizer


mini_batch_size = 1024
no_of_epocs = 4

print('Laster datasett...')
dataframe = pd.read_csv("./bowling.csv")
for i in range(5):
    dataframe = dataframe.append(dataframe)

labels = dataframe['poeng']
three_frames = dataframe[['k1', 'k2', 'k3', 'k4', 'k5', 'k6']]

print('Setter opp onehot encoders...')
throw_hits_encoder = LabelBinarizer().fit(three_frames.iloc[:, 0])
labels_onehot_encoded = LabelBinarizer().fit_transform(labels)
onehot_size = len(throw_hits_encoder.classes_)

feature_vector_length = three_frames.shape[1] * onehot_size

print('Encoder X...')
features = np.zeros((dataframe.shape[0], feature_vector_length))
for hidden_layer in range(three_frames.shape[1]):
    features[:, hidden_layer * onehot_size:(hidden_layer + 1) * onehot_size] = \
        throw_hits_encoder.transform(three_frames['k' + str(hidden_layer + 1)])

print('Setter opp Keras-modell...')
model = Sequential()
for hidden_layer in range(1):
    model.add(Dense(feature_vector_length, input_shape=(feature_vector_length,), activation='relu'))
output_vector_length = labels_onehot_encoded.shape[1]
model.add(Dense(output_vector_length, activation='softmax'))
model.compile(optimizer='adam', loss='categorical_crossentropy', metrics=['accuracy'])

print('Setter opp Tensor Board...')
run_id = "{} {}K {}E {}MB".format(time.strftime("%Y-%m-%d %H:%M:%S"),
                                  features.shape[0] / 1_000,
                                  no_of_epocs,
                                  mini_batch_size)
tensor_board_callback = callbacks.TensorBoard(log_dir='./graph/' + run_id,
                                              histogram_freq=0,
                                              write_graph=True,
                                              write_images=True,
                                              batch_size=mini_batch_size)

print('Trener modell...')
model.fit(features, labels_onehot_encoded,
          epochs=no_of_epocs,
          batch_size=mini_batch_size,
          callbacks=[tensor_board_callback])

print('Lagrer modell...')
model.save("bowling.h5")

