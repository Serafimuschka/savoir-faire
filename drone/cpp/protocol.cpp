#include <iostream>
#include <iomanip>
using namespace std;

int main()
{
	system("chcp 1251");
	system("cls");

	// Ключи, хранящиеся в памяти дрона:
	const unsigned char key = 0x49;

	// Входящий пакет данных в 40 бит:
	unsigned char incoming[5] = { 0x4C, 0xF2, 0x1F, 0xF4, 0x09 };

	// Транслированный пакет команд:
	unsigned char translated[4];

	// Сначала обработаю ключи:
	bool operandL = (0xF0 & incoming[0]) == (0xF0 & key);
	bool operandR = (0x0F & incoming[4]) == (0x0F & key);

	if (operandL && operandR)
	{
		cout << "Ключи совпали, трансляция команды\n";
		// Транслирую команды с помощью масок
		translated[0] = ((0x0F & incoming[0]) << 4) | ((0xF0 & incoming[1]) >> 4);
		translated[1] = ((0x0F & incoming[1]) << 4) | ((0xF0 & incoming[2]) >> 4);
		translated[2] = ((0x0F & incoming[2]) << 4) | ((0xF0 & incoming[3]) >> 4);
		translated[3] = ((0x0F & incoming[3]) << 4) | ((0xF0 & incoming[4]) >> 4);

		cout << "Транслированные команды: ";
		for (char i = 0; i < 4; i++) cout << setw(2) << setfill('0') << hex << static_cast<unsigned short>(translated[i]) << " ; ";
		cout << endl;
	}

	else cout << "Ключи не совпадают, пакет будет проигнорирован\n";

	system("pause>0");
	return 0;
}