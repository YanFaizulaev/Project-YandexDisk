//
//  Constans.swift
//  Skillbox Drive
//
//  Created by Bandit on 18.01.2023.
//

import UIKit

enum Constans {

    enum Fonts {
        static var graphik13: UIFont? {
            UIFont(name: "Graphik-Extralight", size: 13)
        }
        static var graphik15: UIFont? {
            UIFont(name: "Graphik-Extralight", size: 15)
        }
        static var graphik17: UIFont? {
            UIFont(name: "Graphik-Extralight", size: 17)
        }
    }
    
    enum Text {
        
        // Onbording Modeule
        static let onbordingButtonNext = Bundle.main.localizedString(forKey: "Onbording.Button.Next", value: "Далее", table: "Localizable")
        static let onbordingButtonEnter = Bundle.main.localizedString(forKey: "Onbording.Button.Enter", value: "Войти", table: "Localizable")
        static let onbordingButtonSkip = Bundle.main.localizedString(forKey: "Onbording.Button.Skip", value: "Пропустить", table: "Localizable")
        
        static let onbordingFirstLabel = Bundle.main.localizedString(forKey: "Onbording.First.Label", value: "Теперь все ваши документы в одном месте", table: "Localizable")
        static let onbordingSecondLabel = Bundle.main.localizedString(forKey: "Onbording.Second.Label", value: "Доступ к файлам без интернета", table: "Localizable")
        static let onbordingThirdLabel = Bundle.main.localizedString(forKey: "Onbording.Third.Label", value: "Делитесь вашими файлами с другими", table: "Localizable")

        // Profile Module
        static let profileTitleLabel = Bundle.main.localizedString(forKey: "Profile.Title.Label", value: "Профиль", table: "Localizable")
        
        static let profileLabelOccupied = Bundle.main.localizedString(forKey: "Profile.Label.Occupied", value: "занято", table: "Localizable")
        static let profileLabelFree = Bundle.main.localizedString(forKey: "Profile.Label.Free", value: "свободно", table: "Localizable")
        
        static let profileLabelUnitBt = Bundle.main.localizedString(forKey: "Profile.Label.UnitBt", value: "байт", table: "Localizable")
        static let profileLabelUnitKb = Bundle.main.localizedString(forKey: "Profile.Label.UnitKb", value: "кг", table: "Localizable")
        static let profileLabelUnitMb = Bundle.main.localizedString(forKey: "Profile.Label.UnitMb", value: "мб", table: "Localizable")
        static let profileLabelUnitGb = Bundle.main.localizedString(forKey: "Profile.Label.UnitGb", value: "гб", table: "Localizable")

        static let profileButtonText = Bundle.main.localizedString(forKey: "Profile.Button.Text", value: "Опубликованные файлы", table: "Localizable")

        static let profileAlertSubText = Bundle.main.localizedString(forKey: "Profile.Alert.SubText", value: "Выйти из профиля?", table: "Localizable")
        static let profileAlertButtonTextExit = Bundle.main.localizedString(forKey: "Profile.Alert.ButtonTextExit", value: "Выйти", table: "Localizable")
        static let profileAlertButtonTextCancel = Bundle.main.localizedString(forKey: "Profile.Alert.ButtonTextCancel", value: "Отмена", table: "Localizable")
        static let profileAlert2TitleText = Bundle.main.localizedString(forKey: "Profile.Alert2.TitleText", value: "Выход", table: "Localizable")
        static let profileAlert2SubText = Bundle.main.localizedString(forKey: "Profile.Alert2.SubText", value: "При выходе ваши данные будут стерты! Вы уверены, что хотите выйти?", table: "Localizable")
        static let profileAlert2ButtonTextYes = Bundle.main.localizedString(forKey: "Profile.Alert2.ButtonTextYes", value: "Да", table: "Localizable")
        static let profileAlert2ButtonTextNo = Bundle.main.localizedString(forKey: "Profile.Alert2.ButtonTextNo", value: "Нет", table: "Localizable")
        
        static let profileOnbordingLabel = Bundle.main.localizedString(forKey: "Profile.Onbording.Label", value: "У вас пока нет опубликованных файлов", table: "Localizable")
        static let profileOnbordingButtonText = Bundle.main.localizedString(forKey: "Profile.OnbordingButton.Text", value: "Обновить", table: "Localizable")

        static let profileButtonCellText = Bundle.main.localizedString(forKey: "Profile.ButtonCell.Text", value: "Удалить публикацию", table: "Localizable")
        static let profileButtonCellText2 = Bundle.main.localizedString(forKey: "Profile.ButtonCell.Text2", value: "Отмена", table: "Localizable")

        // Last Files Module
        static let lastTitleLabel = Bundle.main.localizedString(forKey: "Last.Title.Label", value: "Последние", table: "Localizable")

        static let lastButtonAlertShareImageTitle = Bundle.main.localizedString(forKey: "Last.Button.Alert.ShareImageTitle", value: "Поделиться", table: "Localizable")
        static let lastButtonAlertButtonTextFile = Bundle.main.localizedString(forKey: "Last.Button.Alert.ButtonTextFile", value: "Файлом", table: "Localizable")
        static let lastButtonAlertButtonTextLink = Bundle.main.localizedString(forKey: "Last.Button.Alert.ButtonTextLink", value: "Ссылкой", table: "Localizable")
        static let lastButtonAlertButtonTextCancel = Bundle.main.localizedString(forKey: "Last.Button.Alert.ButtonTextCancel", value: "Отмена", table: "Localizable")
        
        static let lastLabelTextLabel = Bundle.main.localizedString(forKey: "Last.Label.TextLabel", value: "Данный файл невозможно открыть", table: "Localizable")
        
        static let lastButton2AlertDeleteImageTitle = Bundle.main.localizedString(forKey: "Last.Button2.Alert.DeleteImageTitle", value: "Данный файл будет удален", table: "Localizable")
        static let lastButton2AlertButtonTextDelete = Bundle.main.localizedString(forKey: "Last.Button2.Alert.ButtonTextDelete", value: "Удалить файл", table: "Localizable")
        static let lastButton2AlertButtonTextCancel = Bundle.main.localizedString(forKey: "Last.Button2.Alert.ButtonTextCancel", value: "Отмена", table: "Localizable")

        static let lastButton3TitleRename = Bundle.main.localizedString(forKey: "Last.Button3.TitleRename", value: "Переименовать", table: "Localizable")
        static let lastButton3ButtonTextDone = Bundle.main.localizedString(forKey: "Last.Button3.ButtonTextDone", value: "Готово", table: "Localizable")
        static let lastTextFieldPlaceholder = Bundle.main.localizedString(forKey: "Last.TextField.Placeholder", value: "Пожалуйста, введите название.", table: "Localizable")

        static let lastAlertNoInternetConnection = Bundle.main.localizedString(forKey: "Last.Alert.NoInternetConnection", value: "Отсутствует подключение к интернету", table: "Localizable")

        // All files Module
        static let allFilesTitleLabel = Bundle.main.localizedString(forKey: "AllFiles.Title.Label", value: "Все файлы", table: "Localizable")

        static let allFilesOnbordingLabel = Bundle.main.localizedString(forKey: "AllFiles.Onbording.Label", value: "Директория не содержит файлов", table: "Localizable")
        
        // Alert no connection
        static let alertNoInternetTitleText = Bundle.main.localizedString(forKey: "AlertNoInternet.TitleText", value: "Отсутствует подключение к интернету", table: "Localizable")

        static let alertNoInternetSubTitleText = Bundle.main.localizedString(forKey: "AlertNoInternet.SubTitleText", value: "Проверьте пожалуйста подключение и обновите таблицу", table: "Localizable")
        static let alertNoInternetButtonTextCancel = Bundle.main.localizedString(forKey: "AlertNoInternet.ButtonTextCancel", value: "Отмена", table: "Localizable")

    }

    enum Image {
        static let imageSkillboxDrive = UIImage(named: "imageSlikkboxDrive")
        static let imageOnbording = UIImage(named: "Group7")
        static let imageOnbording2 = UIImage(named: "Group9")
        static let imageOnbording3 = UIImage(named: "Group10")
        static let imageOn = UIImage(named: "On")
        static let imageOn2 = UIImage(named: "On1")
        static let imageOn3 = UIImage(named: "On2")
        static let imageOnbording4 = UIImage(named: "Group21168")
        static let iconFile = UIImage(named: "IconFile")
    }

    enum Color {
        static var colorButton : UIColor? {
            UIColor(hexString: "383FF5")
        }
        static var grayItems : UIColor? {
            UIColor(hexString: "9E9E9E")
        }
        static var colorButtonUpdate : UIColor? {
            UIColor(hexString: "F1AFAA")
        }
    }
}


