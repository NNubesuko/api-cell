import { Controller, Get } from "@nestjs/common";

interface Test {
    message: string;
}

@Controller("test")
export default class TextController {
    @Get()
    public async get(): Promise<Test> {
        return {
            message: "Hi, this is a GET request!",
        };
    }
}