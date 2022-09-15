import {BadRequestError, NotFoundError} from "../utils/error.js";

export class UserService {
    constructor(userRepository) {
        this._userRepository = userRepository;
    }

    async getById(id) {
        const user = await this._userRepository.findOneBy({ id });
        if (user === null) {
            throw new NotFoundError(`User with id ${id} is not found`);
        }
        return user;
    }

    async getAll() {
        return await this._userRepository.find({
            select: {
                id: true,
                name: true,
            }
        });
    }

    async create(createUserDto) {
        const foundByEmail = await this._userRepository.findOneBy({ email: createUserDto.email })
        if (foundByEmail) {
            throw new BadRequestError(`User with email ${createUserDto.email} already exists`);
        }
        return await this._userRepository.save(createUserDto);
    }
}
