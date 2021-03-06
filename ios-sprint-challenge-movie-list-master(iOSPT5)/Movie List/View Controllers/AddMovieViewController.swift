//
//  AddMovieViewController.swift
//  Movie List
//
//  Created by David Williams on 2/9/20.
//  Copyright © 2020 Lambda School. All rights reserved.
//

import UIKit

protocol AddMovieDelegate: AnyObject {
    func movieWasAdded(_ movie: Movie)
}

class AddMovieViewController: UIViewController {

    @IBOutlet weak var movieTitleTextField: UITextField!
    @IBOutlet weak var movieYearTextField: UITextField!
    @IBOutlet weak var editMovieTitleLabel: UILabel!
    @IBOutlet weak var addUpdateButtonLabel: UIButton!
    
    var movieConntroller: MovieController?
    var movie: Movie?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .gray
        movieTitleTextField.backgroundColor = .lightGray
        movieYearTextField.backgroundColor = .lightGray
        [movieTitleTextField, movieYearTextField].forEach { $0?.delegate = self }
        updateViews()
    }
    
    func updateViews() {
        loadViewIfNeeded()
        guard let movie = movie else { return }
        movieTitleTextField.text =  movie.name
        movieYearTextField.text = movie.year
        editMovieTitleLabel.text = "Edit Movie"
        addUpdateButtonLabel.setTitle("Update Movie", for: [])
        // changes navigationItem title color
        let textAttributes = [NSAttributedString.Key.foregroundColor:UIColor.red]
        navigationController?.navigationBar.titleTextAttributes = textAttributes
        title = movie.name
    }
    
    @IBAction func addMoviePressed(_ sender: Any) {
        guard let movieName = movieTitleTextField.text,
            let movieYear = movieYearTextField.text,
            !movieName.isEmpty,
            !movieYear.isEmpty,
            movieYear.isInt else { return }
        if let movie = movie {
            movieConntroller?.editMovie(movie: movie, movieName, year: movieYear)
        } else {
            movieConntroller?.createMovie(named: movieName, year: movieYear)
        }
        navigationController?.popViewController(animated: true)
    }
}

extension AddMovieViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        guard let text = textField.text,
            !text.isEmpty else { return false }
        switch textField {
        case movieTitleTextField:
            movieYearTextField.becomeFirstResponder()
        case movieYearTextField:
            addMoviePressed(textField)
        default:
            textField.resignFirstResponder()
        }
        return false
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange,
                   replacementString string: String) -> Bool
    {
        let maxLength = 4
        // checks a specific user input to set input string length
        guard case movieYearTextField.text = textField.text else { return true}
        let currentString: NSString = textField.text! as NSString
        let newString: NSString =
            currentString.replacingCharacters(in: range, with: string) as NSString
        return newString.length <= maxLength
    }
}

extension String {
    var isInt: Bool {
        return Int(self) != nil
    }
}
