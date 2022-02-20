//
//  AppErrorDefine.swift
//  Soulfully
//
//  Created by Vo The Dong An on 18/02/2022.
//

import Foundation

struct AppError: Codable, Error {
	var status: String?
	var errors: [String]?
	var httpErrorMessage: String?
	var detail: String?
	var errorMessage: String?
	
	enum CodingKeys: String, CodingKey {
		case status, errors, detail
		case httpErrorMessage = "http_error_message"
		case errorMessage = "error_message"
	}
}

extension AppError {
	var actualErrorMessage: String {
		errors?.reduce("", { $0 + "\n" + $1}) ?? detail ?? "Uknown Error"
	}
}
