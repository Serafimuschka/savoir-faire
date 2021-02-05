/*
 Name:    ko_firmware.ino
 Created: 18.01.2021 17:45:29
 Author:  EuthanasiaTrip aka Matvey aka The best pilot RTK has ever seen
*/
#include "Names.h"
#include "IOpins.h"
byte bufferInc[MSG_BYTES];      // �������� �����
byte bufferFbk[CMD_BYTES];      // ����� �������
byte bufTranslated[CMD_BYTES];    // ����� ������
int thumperMsg = 0;
bool automoveFlag = false;

void setup() {
  Serial.begin(9600);
  Serial1.begin(9600);
  for (int i =2; i <12; i++) pinMode(i, OUTPUT);
  for (int i = 23; i < 49; i += 2) pinMode(i, INPUT);
}

void loop() {
  msgRead();
  droneTask(bufTranslated[0], bufTranslated[1]);
  droneTask(bufTranslated[2], bufTranslated[3]);
}

void msgRead() {
  if (Serial.available()) {
    for (int i = 0; i < MSG_BYTES; i++) { 
      bufferInc[i] = Serial.read(); // ���������� �������� �����
    }
  }
  if ((bufferInc[0] & 0xF0) == (BYTE_KEY & 0xF0) && (bufferInc[MSG_BYTES - 1] & 0x0F) == (BYTE_KEY & 0x0F)) { // ���������� ������ � ��������� 4 ���� � ������
    for (int i = 0; i < (CMD_BYTES); i++) {
      bufTranslated[i] = ((0x0F & bufferInc[i]) << 4) | ((0xF0 & bufferInc[i+1]) >> 4); // ���������� ���������� 32 ���� � ����� ��� �������                               
    }
  }
  for (int i = 0; i < MSG_BYTES; i++) {
    bufferInc[i] = 0; // ������� ������� �����
  }
}

void droneTask(const byte cmd, const byte value) {
    switch (cmd)
    {
    case AUTOMOVE:
        if (value) {
            if (!automoveFlag) {  // ���� ���� �� �����
                automoveFlag = true; // �� �� ����� �����
                automove();         // ���������
                Serial.print(CMD_SUCCESS);
            }
            else {
                automoveFlag = false; // ���� ����� �� ����������� ���
            }
        }
        else {
            Serial.print(INVALID_INPUT);
        }
        break;
    case LASER:
        if (value) {
            if (digitalRead(3) == LOW) {
                digitalWrite(3, HIGH);
            }
            else digitalWrite(3, LOW);
            Serial.print(CMD_SUCCESS);
        }
        else {
            Serial.print(INVALID_INPUT);
        }
        break;
    case LIGHTS:
        if (value) {
            if (digitalRead(4) == LOW) {
                digitalWrite(4, HIGH);
            }
            else digitalWrite(4, LOW);
            Serial.print(CMD_SUCCESS);
        }
        else {
            Serial.print(INVALID_INPUT);
        }
        break;

    default:
        Serial.print(INVALID_CMD);
        break;
    }
}

void automove() {
    while (automoveFlag) {
        // ���� �� ����� �� ������ �������� ���� ������, �� ���� ������������ ������
        if (((digitalRead(IR_RIGHT_1) == HIGH) || (digitalRead(IR_RIGHT_2) == HIGH)) && (digitalRead(IR_LEFT_1) == LOW) && (digitalRead(IR_LEFT_2) == LOW)) { 
            thumperTranslate(75, -75, 75, -75);
       }
        // ���� �� ����� �� ����� �������� ���� ������, �� ���� ������������ �����
        if (((digitalRead(IR_LEFT_1) == HIGH) || (digitalRead(IR_LEFT_2) == HIGH)) && (digitalRead(IR_RIGHT_1) == LOW) && (digitalRead(IR_RIGHT_2) == LOW)) {
            thumperTranslate(-75, 75, -75, 75);
        }
        // ���� �� �� ����� �� �������� ��� �������, �� ���� ���� �����
        if ((digitalRead(IR_RIGHT_1) == LOW) && (digitalRead(IR_RIGHT_2) == LOW) && (digitalRead(IR_LEFT_1) == LOW) && (digitalRead(IR_LEFT_2) == LOW)) {
            thumperTranslate(75, 75, 75, 75);
        }
    }
}

void thumperTranslate(char fr, char fl, char rr, char rl) {
    // ������ ���� �������� �� ����������� ������ � ������ �������� ����������� � 4� �������� �����
    thumperMsg = ((thumperMsg & 0xFF000000) & (fr << 24)) | ((thumperMsg & 0x00FF0000) & (fl << 16)) | ((thumperMsg & 0x0000FF00) & (rr << 8)) | ((thumperMsg & 0x000000FF) & rl);
    // ����� ��� ����� ���������� �� ����� �������
    if (Serial1.available() > 0) {
        Serial1.print(thumperMsg);
    }
    else Serial.print(THUMPER_CONNECTION_FAILURE);
}
